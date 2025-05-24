import 'package:flutter_test/flutter_test.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqlite/helpers/database_helper.dart';
import 'package:sqlite/models/task.dart';

void main() {
  late DatabaseHelper dbHelper;

  setUpAll(() async {
    // Initialize sqflite_common_ffi for testing
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    // Inisialisasi database in-memory untuk testing
    dbHelper = DatabaseHelper();
    final db = await dbHelper.database;
    await db.delete('tasks');
  });

  test('Insert and retrieve tasks', () async {
    await dbHelper.insertTask(Task(title: 'Test Task'));
    final tasks = await dbHelper.getTasks();

    expect(tasks.length, 1);
    expect(tasks.first.title, 'Test Task');
  });

  test('Delete a task', () async {
    // kerjakan
  });

  test('Check deadline', () async {
    // kerjakan
  });
}
