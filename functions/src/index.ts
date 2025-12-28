import {onCall, HttpsError} from "firebase-functions/v2/https";
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

export const generateWorkoutTemplate = onCall(
  {secrets: [OPENAI_API_KEY], timeoutSeconds: 60},
  async (req) => {
    try {
      const user = req.data as any;
      const {
        sex,
        level,
        equipment,
        daysPerWeek,
        sessionDurationMin,
        constraints,
      } = user;

      const client = new OpenAI({apiKey: OPENAI_API_KEY.value()});

      const prompt = `
Return STRICT JSON only (no markdown).

Rules:
- Default rep range is 6-8 reps.
- Working sets must be 3-5 per exercise.
- Each workout day has 4-6 exercises.
- Include warm-up protocol globally:
  50%x6, 70%x4, 85%x2(optional).
  Beginners may use only the first 1-2 warm-up sets.
- Warm-ups apply to main and secondary lifts; accessories usually no warm-up.
- Exceptions ONLY for lateral raises, face pulls, calves, abs may use 8-12 reps.
- Choose safe, common exercises suitable for the equipment.
- Use stable snake_case exerciseId values.

- sex: ${sex}

Guidelines for sex:
- Keep the same structure for all users.
- If sex is female:
  - Bias towards 4–5 working sets on lower-body movements (still within 3–5).
  - Keep overhead pressing volume conservative.
- If sex is male:
  - Default 3–4 working sets unless explicitly needed.
- Rep range rules remain the same (6–8).

Schema:
{
  "schemaVersion": 1,
  "planName": string,
  "level": "beginner"|"intermediate"|"advanced",
  "equipment": "gym"|"home_dumbbells"|"calisthenics",
  "daysPerWeek": number,
  "sessionDurationMin": number,
  "globalDefaults": {
    "repRange": {"min": number, "max": number},
    "warmup": {
      "enabled": boolean,
      "protocol": [{"percentOfWorkingWeight": number, "reps": number, "optional"?: boolean}]
    },
    "restSeconds": {"compound": number, "accessory": number},
    "workingSetsByLiftClass": {"main": number, "secondary": number, "accessory": number}
  },
  "days": [
    {
      "dayIndex": number,
      "title": string,
      "exercises": [
        {
          "exerciseId": string,
          "name": string,
          "liftClass": "main"|"secondary"|"accessory",
          "movement": string,
          "equipmentType": string,
          "workingSets": number,
          "repRange": {"min": number, "max": number},
          "restSeconds": number,
          "warmup": {"useGlobal": boolean}
        }
      ]
    }
  ]
}

User:
${JSON.stringify({
    level,
    equipment,
    daysPerWeek,
    sessionDurationMin: sessionDurationMin ?? 60,
    constraints: constraints ?? "none",
  })}
`;

      const resp = await client.responses.create({
        model: "gpt-4o-mini",
        input: prompt,
      });

      const text = (resp.output_text ?? "").trim();

      try {
        return {ok: true, template: JSON.parse(text)};
      } catch {
        return {ok: false, raw: text};
      }
    } catch (err: any) {
      console.error(err);
      throw new HttpsError(
        "internal",
        err?.message ?? "Failed to generate workout template"
      );
    }
  }
);


