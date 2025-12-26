import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('PrimeForm')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Welcome back', style: theme.textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              'Plan your week, log your check-ins, and track trends — offline-first.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),

            FilledButton(
              onPressed: () => Navigator.pushNamed(context, '/plan'),
              child: const Text('Create Plan'),
            ),
            const SizedBox(height: 12),
            
            FilledButton.tonal(
              onPressed: () => Navigator.pushNamed(context, '/myplan'),
              child: const Text('My Plan'),
            ),
            const SizedBox(height: 12),

            FilledButton.tonal(
              onPressed: () => Navigator.pushNamed(context, '/checkin'),
              child: const Text('Daily Check-in'),
            ),
            const SizedBox(height: 12),

            OutlinedButton(
              onPressed: () => Navigator.pushNamed(context, '/trends'),
              child: const Text('Trends'),
            ),

            const Spacer(),

            FilledButton.tonal(
              onPressed: () async {
                final callable =
                    FirebaseFunctions.instance.httpsCallable('generatePlan');

                final res = await callable.call({
                  "age": 40,
                  "sex": "male",
                  "heightCm": 175,
                  "weightKg": 75.2,
                  "goal": "cut",
                  "daysPerWeek": 4,
                  "equipment": "gym access",
                });

                // ignore: avoid_print
                print(res.data);

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(res.data.toString())),
                  );
                }
              },
              child: const Text('AI Plan Smoke Test'),
            ),
          ],
        ),
      ),
    );
  }
}
