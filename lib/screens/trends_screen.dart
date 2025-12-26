import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:primeform_app/state/providers.dart';

class TrendsScreen extends ConsumerWidget {
  const TrendsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checkInsAsync = ref.watch(latestCheckInsStreamProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Trends')),
      body: checkInsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (items) {
          if (items.isEmpty) {
            return const Center(child: Text('No check-ins yet.'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(height: 24),
            itemBuilder: (context, i) {
              final c = items[i];
              return ListTile(
                title: Text('${c.weightKg.toStringAsFixed(1)} kg • ${c.waistCm.toStringAsFixed(1)} cm'),
                subtitle: Text('${c.ts} • steps: ${c.stepsToday}${c.note == null ? "" : " • ${c.note}"}'),
              );
            },
          );
        },
      ),
    );
  }
}
