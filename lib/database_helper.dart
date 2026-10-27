import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  // CREATE OR OPEN DATABASE
  static Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    final dbPath = await getDatabasesPath();

    final path = join(dbPath, 'weekend_vibe.db');

    _database = await openDatabase(
      path,
      version: 1,

      onCreate: (db, version) async {
        // ACTIVITIES TABLE
        await db.execute('''
          CREATE TABLE activities (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            completed INTEGER NOT NULL DEFAULT 0
          )
        ''');

        // PROFILE TABLE
        await db.execute('''
          CREATE TABLE profile (
            id INTEGER PRIMARY KEY,
            name TEXT NOT NULL,
            email TEXT NOT NULL
          )
        ''');

        // SETTINGS TABLE
        await db.execute('''
          CREATE TABLE settings (
            key TEXT PRIMARY KEY,
            value INTEGER NOT NULL
          )
        ''');
      },
    );

    return _database!;
  }

  // ==========================
  // ACTIVITIES
  // ==========================

  // ADD ACTIVITY
  static Future<void> addActivity(String name) async {
    final db = await database;

    await db.insert('activities', {'name': name, 'completed': 0});
  }

  // GET ALL ACTIVITIES
  static Future<List<Map<String, dynamic>>> getActivities() async {
    final db = await database;

    return await db.query('activities', orderBy: 'id DESC');
  }

  // UPDATE ACTIVITY
  static Future<void> updateActivity(int id, bool completed) async {
    final db = await database;

    await db.update(
      'activities',
      {'completed': completed ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // DELETE ACTIVITY
  static Future<void> deleteActivity(int id) async {
    final db = await database;

    await db.delete('activities', where: 'id = ?', whereArgs: [id]);
  }

  // ==========================
  // USER PROFILE
  // ==========================

  // SAVE PROFILE
  static Future<void> saveProfile(String name, String email) async {
    final db = await database;

    await db.insert('profile', {
      'id': 1,
      'name': name,
      'email': email,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // GET PROFILE
  static Future<Map<String, dynamic>?> getProfile() async {
    final db = await database;

    final result = await db.query('profile', where: 'id = ?', whereArgs: [1]);

    if (result.isNotEmpty) {
      return result.first;
    }

    return null;
  }

  // ==========================
  // APPLICATION SETTINGS
  // ==========================

  // SAVE SETTING
  static Future<void> saveSetting(String key, bool value) async {
    final db = await database;

    await db.insert('settings', {
      'key': key,
      'value': value ? 1 : 0,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // GET SETTING
  static Future<bool?> getSetting(String key) async {
    final db = await database;

    final result = await db.query(
      'settings',
      where: 'key = ?',
      whereArgs: [key],
    );

    if (result.isEmpty) {
      return null;
    }

    return result.first['value'] == 1;
  }
}
