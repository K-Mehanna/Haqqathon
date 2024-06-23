import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._();
  late Database _database;

  DatabaseHelper._();

  factory DatabaseHelper() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'app_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        village_id INTEGER,
        name TEXT,
        age INTEGER,
        last_visited STRING,
        doctor NAME,
        dental_notes TEXT,
        medical_notes TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE village(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        latitude REAL,
        longitude REAL
      )
    ''');
    await db.execute('''
      CREATE TABLE db(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        villageIds TEXT  -- This will be a comma-separated list of village IDs
      )
    ''');
  }

  Future<int> insertUser(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert('users', row);
  }

  Future<int> insertVillage(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert('village', row);
  }

  Future<int> insertDb(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert('db', row);
  }

  Future<List<Map<String, dynamic>>> queryAllUsers() async {
    Database db = await database;
    return await db.query('users');
  }

  Future<List<Map<String, dynamic>>> queryAllVillages() async {
    Database db = await database;
    return await db.query('village');
  }

  Future<List<Map<String, dynamic>>> queryAllDbs() async {
    Database db = await database;
    return await db.query('db');
  }
}
