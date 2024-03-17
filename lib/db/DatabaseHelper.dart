import 'package:ankitatodotask/models/todo_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const dbName = 'TodoDB.db';
  static const _databaseVersion = 1;

  static const table = 'Todos';

  static const columnId = 'id';
  static const columnTitle = 'title';
  static const columnDesc = 'description';
  static const columnTime = 'timer';
  static const columnTimes = 'timeString';
  static const columnStatus = 'status';
  static const columnStatusID = 'statusID';

  // make this a singleton class
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper _databaseService = DatabaseHelper._internal();
  factory DatabaseHelper() => _databaseService;
  DatabaseHelper._internal();

  // only have a single app-wide reference to the database
  static Database? _db;
  Future<Database?> get database async {
    if (_db != null) return _db;
    // lazily instantiate the db the first time it is accessed
    _db = await initDB();
    return _db;
  }

  Future<Database?> initDB() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();

    final path = join(documentsDirectory.path, dbName);

    _db = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );

    return _db;
  }

  Future _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE $table ("
        "${columnId} INTEGER PRIMARY KEY AUTOINCREMENT, "
        "${columnTitle} TEXT, "
        "${columnDesc} TEXT, "
        "${columnStatusID} INTEGER, "
        "${columnStatus} TEXT, "
        "${columnTime} INTEGER ,"
        "${columnTimes} TEXT "
        ")");
  }

  Future<int> insert(Map<String, dynamic> row) async {
    final db = await _databaseService.database;
    return await db!.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    final db = await _databaseService.database;
    return await db!.query(table);
  }

  Future<int> queryRowCount() async {
    final db = await _databaseService.database;
    final results = await db!.rawQuery('SELECT COUNT(*) FROM $table');
    return Sqflite.firstIntValue(results) ?? 0;
  }

  Future<TodoModel> getTodoDetails(int id) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps =
        await db!.query(table, where: 'id = ?', whereArgs: [id]);
    return TodoModel.fromMap(maps[0]);
  }

  Future<int> update(Map<String, dynamic> row) async {
    final db = await _databaseService.database;
    int id = row[columnId];
    return await db!.update(
      table,
      row,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future<int> delete(int id) async {
    final db = await _databaseService.database;
    return await db!.delete(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }
}
