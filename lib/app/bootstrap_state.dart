import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/local/database/app_database.dart';

sealed class BootstrapState {
  const BootstrapState();
}

final class BootstrapReady extends BootstrapState {
  const BootstrapReady();
}

final class BootstrapFailed extends BootstrapState {
  const BootstrapFailed(this.failure);

  final Object failure;
}

final bootstrapStateProvider = Provider<BootstrapState>(
  (ref) => throw StateError('Bootstrap has not run.'),
);

final databaseProvider = Provider<AppDatabase>(
  (ref) =>
      throw StateError('Database is available after a successful bootstrap.'),
);
