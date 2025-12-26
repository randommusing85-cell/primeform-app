import 'package:flutter/material.dart';

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
              onPressed: () => Navigator.pushNamed(context, '/checkin'),
              child: const Text('Daily Check-in'),
            ),
            const SizedBox(height: 12),

            OutlinedButton(
              onPressed: () => Navigator.pushNamed(context, '/trends'),
              child: const Text('Trends'),
            ),
          ],
        ),
      ),
    );
  }
}
