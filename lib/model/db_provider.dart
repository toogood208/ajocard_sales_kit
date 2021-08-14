import 'package:ajocard_sales_kit/model/task_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  // create a private constructor for database class
  DBProvider._();
  static final DBProvider dataBase = DBProvider._();
  static Database? _database;

  //create a getter for the database
  Future<Database?> get database async {
    // check if database already exist return it else, create database
    if (_database != null) {
      return _database;
    } else {
      _database = await initDatabase();
      return _database;
    }
  }

  // initiate the database
  initDatabase() async {
    return await openDatabase(join(await getDatabasesPath(), "to_do.db"),
        onCreate: (db, version) async {
      await db.execute("""
      CREATE TABLE tasks(id INTEGER PRIMARY KEY AUTOINCREMENT, task TEXT, date TEXT)
      """);
    }, version: 1);
  }

  // create a function to add new tasks
  addNewTask(Task newTask) async {
    final db = await database;
    db?.insert("tasks", newTask.toMap());
  }

  // get data from databse
  Future<dynamic> getTask() async {
    final db = await database;
    var result = await db!.query("tasks");
    if (result.length == 0) {
      return Null;
    } else {
      var resultMap = result.toList();
      return resultMap.isNotEmpty ? resultMap : Null;
    }
  }

  // create a delete function
  Future<int> deleteTask(int id) async {
    final db = await database;
    int count = await db!.rawDelete("DELETE From tasks WHERE id = ?", [id]);
    return count;
  }
}
