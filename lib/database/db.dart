import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBapps {
  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  Future<Database> initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'user.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT UNIQUE,
            password TEXT
          )
        ''');

        // Buat akun default 'Admin' saat database pertama kali dibuat
        await db.insert('users', {
          'username': 'Admin',
          'password': 'Admin1234',
        });
      },
    );
  }

  /// Mengambil pengguna berdasarkan username dan password.
  /// Mengembalikan Map data pengguna jika ditemukan, jika tidak null.
  Future<Map<String, dynamic>?> getUser(String username, String password) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    if (result.isNotEmpty) {
      return result.first; // Kembalikan data pengguna jika ditemukan
    }
    return null; // Kembalikan null jika tidak ada yang cocok
  }
}
