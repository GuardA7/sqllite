import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';
import 'package:sqlite/models/task.dart';

class DatabaseHelper {
  static Database? _database;
  static const String _tableName = 'tasks';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'tasks.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(''' 
          CREATE TABLE $_tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            isCompleted INTEGER DEFAULT 0,
            deadline TEXT
          )
        ''');
      },
    );
  }

  // CRUD Methods
  Future<int> insertTask(Task task) async {
    final db = await database;
    return await db.insert(_tableName, task.toMap());
  }

  Future<List<Task>> getTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_tableName);
    return List.generate(maps.length, (i) {
      return Task(
        id: maps[i]['id'],
        title: maps[i]['title'],
        isCompleted: maps[i]['isCompleted'] == 1,
        deadline:
            maps[i]['deadline'] != null
                ? DateTime.parse(maps[i]['deadline'])
                : null,
      );
    });
  }

  // Add the deleteTask method
  Future<void> deleteTask(int id) async {
    final db = await database;
    await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  // Optionally, you can add a method to update tasks as well
  Future<void> updateTask(Task task) async {
    final db = await database;
    await db.update(
      _tableName,
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }
}
