import 'package:myapp/models/mhs_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class MyDb {
  Future<Database> database() async {
    final db = await openDatabase(
      join(await getDatabasesPath(), 'mhs_data.db'),
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE mahasiswa(id INTEGER PRIMARY KEY, nim TEXT, nama TEXT)',
        );
        await db.execute(
          'CREATE TABLE users(id INTEGER PRIMARY KEY, username TEXT, password TEXT)',
        );
        // Add a default user for testing
        await db.insert(
          'users',
          {'username': 'admin', 'password': 'admin'},
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      },
      version: 1,
    );
    return db;
  }

  // Function to check user credentials
  Future<Map<String, dynamic>?> getUser(String username, String password) async {
    final db = await database();
    final List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  Future<List<MhsModel>> getMahasiswa() async {
    List<MhsModel> mahasiswa = [];
    final db = await database();
    final data = await db.query('mahasiswa');
    for (var mhs in data) {
      MhsModel myMhs = MhsModel.fromMap(mhs);
      mahasiswa.add(myMhs);
    }
    return mahasiswa;
  }

  Future<void> insertMhs(MhsModel mhs) async {
    final db = await database();
    await db.insert(
      'mahasiswa',
      mhs.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateMhs(MhsModel mhs) async {
    final db = await database();
    await db.update(
      'mahasiswa',
      mhs.toMap(),
      where: 'id = ?',
      whereArgs: [mhs.id],
    );
  }

  Future<void> deleteMhs(MhsModel mhs) async {
    final db = await database();
    await db.delete(
      'mahasiswa',
      where: 'id = ?',
      whereArgs: [mhs.id],
    );
  }
}
