import 'package:isar/isar.dart';
import 'package:primeform_app/db/isar_db.dart';
import 'package:primeform_app/models/checkin.dart';
import 'package:primeform_app/models/prime_plan.dart';

class PrimeRepo {
  Future<void> addCheckIn(CheckIn c) async {
    final isar = await IsarDb.instance();
    await isar.writeTxn(() async {
      await isar.checkIns.put(c);
    });
  }

  Future<List<CheckIn>> latestCheckIns({int limit = 30}) async {
    final isar = await IsarDb.instance();
    return isar.checkIns.where().sortByTsDesc().limit(limit).findAll();
  }

  Stream<List<CheckIn>> watchLatestCheckIns({int limit = 30}) async* {
    final isar = await IsarDb.instance();
    yield* isar.checkIns
        .where()
        .sortByTsDesc()
        .limit(limit)
        .watch(fireImmediately: true);
  }

  Future<void> upsertPlan(PrimePlan plan) async {
    final isar = await IsarDb.instance();
    await isar.writeTxn(() async {
      await isar.primePlans.put(plan);
    });
  }

  Future<PrimePlan?> getActivePlan() async {
    final isar = await IsarDb.instance();
    return isar.primePlans.where().sortByCreatedAtDesc().findFirst();
  }
}
