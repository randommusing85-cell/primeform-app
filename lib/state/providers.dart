import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:primeform_app/repos/prime_repo.dart';
import 'package:primeform_app/models/checkin.dart';
import 'package:primeform_app/models/prime_plan.dart';

final primeRepoProvider = Provider<PrimeRepo>((ref) => PrimeRepo());

final latestCheckInsStreamProvider = StreamProvider.autoDispose<List<CheckIn>>((
  ref,
) {
  final repo = ref.watch(primeRepoProvider);
  return repo.watchLatestCheckIns(limit: 30);
});

final activePlanProvider = FutureProvider.autoDispose<PrimePlan?>((ref) async {
  final repo = ref.watch(primeRepoProvider);
  return repo.getActivePlan();
});
