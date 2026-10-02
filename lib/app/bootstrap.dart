import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/errors/app_failure.dart';
import '../core/errors/local_log.dart';
import '../data/content/loaders/bundled_content_loader.dart';
import '../data/content/validators/content_validator.dart';
import '../data/local/database/app_database.dart';
import '../data/local/database/open_database.dart';
import 'bootstrap_state.dart';

Future<ProviderContainer> bootstrap() async {
  AppDatabase? database;
  try {
    database = await openAppDatabase();
    final manifest = await const BundledContentLoader().loadBundled();
    final validation = const ContentValidator().validate(manifest);
    if (!validation.usable) {
      LocalLog.debug('content pack unusable');
      await database.close();
      return _failed(const ContentFailure());
    }
    final opened = database;
    return ProviderContainer(
      overrides: [
        bootstrapStateProvider.overrideWithValue(const BootstrapReady()),
        databaseProvider.overrideWith((ref) {
          ref.onDispose(opened.close);
          return opened;
        }),
      ],
    );
  } on ContentPackParseException {
    LocalLog.debug('content pack parse failed');
    await database?.close();
    return _failed(const ContentFailure());
  } catch (_) {
    LocalLog.debug('bootstrap failed');
    await database?.close();
    return _failed(const DatabaseFailure());
  }
}

ProviderContainer _failed(AppFailure failure) {
  return ProviderContainer(
    overrides: [
      bootstrapStateProvider.overrideWithValue(BootstrapFailed(failure)),
    ],
  );
}
