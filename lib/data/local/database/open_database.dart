import 'dart:io';

import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';

import 'app_database.dart';

Future<AppDatabase> openAppDatabase() async {
  final directory = await getApplicationSupportDirectory();
  final file = File(p.join(directory.path, 'sproutlab.sqlite'));
  return AppDatabase(
    NativeDatabase.createInBackground(file, setup: _configureSqlite),
  );
}

void _configureSqlite(Database database) {
  database.execute('PRAGMA journal_mode = WAL');
  database.execute('PRAGMA foreign_keys = ON');
}
