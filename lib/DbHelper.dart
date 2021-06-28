import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'models/TaskModel.dart';

class DbHelper {
  static final _databasename = "tolove.db";
  static final _databaseversion = 1;

  // the table name
  static final _tasktable = "task_table";
  static final _todotable = "todo_table";

  // column names for tasktable
  final String _tasktitleColumn = 'title';
  final String _taskdescColumn = 'desc';
  final String _taskdateColumn = 'date';
  final String _taskpirorityColumn = 'pirority';
  final String _taskstatusColumn = 'status';
  final String _taskidColumn = 'id';

  // column names fot todotable
  final String _todoidColumn = 'id';
  final String _todotaskIdColumn = 'taskid';
  final String _todotitleColumn = 'title';
  final String _todostatusColumn = 'status';

  static Database _database;
// CREATE DATABSE
  Future openDb() async {
    if (_database == null) {
      _database = await openDatabase(
          join(await getDatabasesPath(), _databasename),
          version: _databaseversion,
          onCreate: (Database db, int version) async {
        await db.execute(
            'CREATE TABLE $_tasktable($_taskidColumn INTEGER PRIMARY KEY autoincrement, $_tasktitleColumn TEXT,$_taskdescColumn TEXT, $_taskdateColumn TEXT, $_taskpirorityColumn TEXT, $_taskstatusColumn  INTEGER);');
        await db.execute(
          'CREATE TABLE $_todotable($_todoidColumn INTEGER PRIMARY KEY autoincrement, $_todotitleColumn TEXT,$_todostatusColumn INTEGER);',
        );
      });
    }
  }

  // INSERT TODO
  Future<int> addTodoTask(Map task) async {
    int taskId = 0;
    await openDb();
    print(task);
    await _database
        .insert(_todotable, task, conflictAlgorithm: ConflictAlgorithm.replace)
        .then((value) {
      print(value);
      taskId = value;
    });
    return taskId;
  }

  // INSERT TASK
  Future<int> addTask(Map task) async {
    int taskId = 0;
    await openDb();
    print(task);
    await _database
        .insert(_tasktable, task, conflictAlgorithm: ConflictAlgorithm.replace)
        .then((value) {
      print(value);
      taskId = value;
    });
    return taskId;
  }

  // GET TASK
  Future<List<TaskModel>> queryAll() async {
    await openDb();
    List<Map<String, dynamic>> taskMap = await _database.query(_tasktable);
    return List.generate(taskMap.length, (index) {
      return TaskModel(
          title: taskMap[index]['title'],
          desc: taskMap[index]['desc'],
          date: taskMap[index]['date'],
          pirority: taskMap[index]['pirority'],
          status: taskMap[index]['status'],
          id: taskMap[index]['id']);
    });
  }

  // GET TODO TASKS
  Future<List<Map<String, dynamic>>> queryallTodo() async {
    await openDb();
    return await _database.query(_todotable);
  }

  Future<void> deleteTask(int id, String table) async {
    await openDb();
    await _database.rawDelete("DELETE FROM $table WHERE id = '$id'");
  }

  Future<void> updateTasks(TaskModel tasks, int id) async {
    try {
      await openDb();
      return await _database
          .update(_tasktable, tasks.toMap(), where: "id = ?", whereArgs: [id]);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> updateStatus(int id, int status, String table) async {
    await openDb();
    await _database
        .rawUpdate("UPDATE $table SET status = '$status' WHERE id = '$id'");
  }
}
