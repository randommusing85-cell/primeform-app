import {onCall} from "firebase-functions/v2/https";
import {defineSecret} from "firebase-functions/params";
import OpenAI from "openai";

const OPENAI_API_KEY = defineSecret("OPENAI_API_KEY");

export const generatePlan = onCall(
  {secrets: [OPENAI_API_KEY], timeoutSeconds: 60},
  async (req) => {
    const user = req.data;

    const client = new OpenAI({apiKey: OPENAI_API_KEY.value()});

    const prompt = `
Return STRICT JSON only (no markdown).
Schema:
{
  "plan_name": string,
  "calories": number,
  "macros": {"protein_g": number, "carbs_g": number, "fat_g": number},
  "training_days": number,
  "split": string[],
  "rules": string[],
  "notes": string[]
}
User:
${JSON.stringify(user)}
`;

    const resp = await client.responses.create({
      model: "gpt-4o-mini",
      input: prompt,
    });

    const text = (resp.output_text ?? "").trim();

    try {
      return {ok: true, plan: JSON.parse(text)};
    } catch {
      return {ok: false, raw: text};
    }
  }
);

export const generateAdjustment = onCall(
  {secrets: [OPENAI_API_KEY], timeoutSeconds: 60},
  async (req) => {
    const {plan, trends} = req.data;

    const client = new OpenAI({apiKey: OPENAI_API_KEY.value()});

    const prompt = `
You are a conservative fitness coach.

Given:
CURRENT PLAN:
${JSON.stringify(plan, null, 2)}

RECENT TRENDS (last 14 days):
${JSON.stringify(trends, null, 2)}

Rules:
- Only suggest SMALL adjustments
- Prefer "hold" if progress is acceptable
- Never adjust calories more than ±150 kcal
- Never adjust steps more than ±2000
- Return STRICT JSON ONLY

Schema:
{
  "action": "hold" | "adjust",
  "calorie_delta": number,
  "step_delta": number,
  "reasoning": string[],
  "confidence": "high" | "medium" | "low"
}
`;

    const resp = await client.responses.create({
      model: "gpt-4o-mini",
      input: prompt,
    });

    const text = resp.output_text?.trim() ?? "";

    try {
      return {ok: true, adjustment: JSON.parse(text)};
    } catch {
      return {ok: false, raw: text};
    }
  }
);

