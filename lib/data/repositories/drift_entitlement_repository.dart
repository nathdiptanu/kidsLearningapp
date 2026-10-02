import 'package:drift/drift.dart';

import '../../domain/models/entitlement_snapshot.dart';
import '../local/database/app_database.dart';

class DriftEntitlementRepository {
  DriftEntitlementRepository(this._database);

  final AppDatabase _database;

  static const cacheRowId = 1;

  /// Reads the single cached row. A missing row stays inactive.
  /// Schema upgrades do not delete this table, activity progress, or rewards.
  /// A cached Premium grant still has to pass the offline window or a known expiry.
  Future<EntitlementSnapshot> read() async {
    final row = await (_database.select(
      _database.entitlementCacheEntries,
    )..where((table) => table.id.equals(cacheRowId))).getSingleOrNull();
    if (row == null) {
      return EntitlementSnapshot.inactive;
    }
    return EntitlementSnapshot(
      status: _status(row.status),
      productId: row.productId,
      expiryMillis: row.expiryMillis,
      lastReconciledAtMillis: row.lastReconciledAt,
    );
  }

  Future<void> save(EntitlementSnapshot snapshot) async {
    await _database
        .into(_database.entitlementCacheEntries)
        .insert(
          EntitlementCacheEntriesCompanion.insert(
            id: const Value(cacheRowId),
            status: snapshot.status.name,
            productId: Value(snapshot.productId),
            expiryMillis: Value(snapshot.expiryMillis),
            lastReconciledAt: Value(snapshot.lastReconciledAtMillis),
          ),
          mode: InsertMode.insertOrReplace,
        );
  }

  EntitlementStatus _status(String stored) {
    for (final status in EntitlementStatus.values) {
      if (status.name == stored) {
        return status;
      }
    }
    return EntitlementStatus.unknown;
  }
}
