import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

@DataClassName("TaskData")
class Tasks extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get title => text().withLength(min: 1, max: 100)();

  TextColumn get description => text().nullable()();

  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
}

@DriftDatabase(tables: [Tasks])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Stream<List<TaskData>> watchAllTasks() =>
      (select(tasks)..orderBy([(tbl) => OrderingTerm.desc(tbl.id)])).watch();

  Stream<List<TaskData>> watchTasksByQuery(String query) {
    if (query.isEmpty) {
      return watchAllTasks();
    }

    return (select(tasks)
          ..where(
            (tbl) =>
                tbl.title.lower().like("%$query%") |
                tbl.description.lower().like("%$query%"),
          )
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.id)]))
        .watch();
  }

  Future<int> insertTask(TasksCompanion task) => into(tasks).insert(task);

  Future<bool> updateTask(TasksCompanion task) => update(tasks).replace(task);

  Future<int> deleteTask(int id) =>
      (delete(tasks)..where((tbl) => tbl.id.equals(id))).go();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
