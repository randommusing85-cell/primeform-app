import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/providers.dart';

class MyPlanScreen extends ConsumerWidget {
  const MyPlanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final planAsync = ref.watch(activePlanProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('My Plan')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: planAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (plan) {
            if (plan == null) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('No plan saved yet', style: theme.textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  const Text('Create a plan first, then it will show up here.'),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => Navigator.pushNamed(context, '/plan'),
                    child: const Text('Create Plan'),
                  ),
                ],
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Active Plan', style: theme.textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text(
                  'Saved on: ${plan.createdAt}',
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 16),
                
                Text(plan.planName, style: theme.textTheme.titleLarge),
                const SizedBox(height: 8),
                Text('Training days: ${plan.trainingDays}/week'),
                const SizedBox(height: 16),

                _StatCard(
                  title: 'Calories',
                  value: '${plan.calories} kcal',
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        title: 'Protein',
                        value: '${plan.proteinG} g',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        title: 'Carbs',
                        value: '${plan.carbsG} g',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        title: 'Fat',
                        value: '${plan.fatG} g',
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                FilledButton.tonal(
                  onPressed: () => Navigator.pushNamed(context, '/plan'),
                  child: const Text('Regenerate / Update Plan'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;

  const _StatCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.labelMedium),
          const SizedBox(height: 6),
          Text(value, style: theme.textTheme.titleLarge),
        ],
      ),
    );
  }
}
