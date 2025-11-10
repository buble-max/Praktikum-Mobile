import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/mhs_model.dart';

class MyDb {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'mahasiswa.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE mahasiswa(
            nim TEXT PRIMARY KEY,
            nama TEXT,
            alamat TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertMhs(MhsModel mhs) async {
    final db = await database;
    await db.insert('mahasiswa', mhs.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<MhsModel>> getMahasiswa() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query('mahasiswa');
    return result
        .map((map) => MhsModel(
              nim: map['nim'],
              nama: map['nama'],
              alamat: map['alamat'],
            ))
        .toList();
  }

  Future<void> deleteMhs(MhsModel mhs) async {
    final db = await database;
    await db.delete('mahasiswa', where: 'nim = ?', whereArgs: [mhs.nim]);
  }

  Future<void> updateMhs(MhsModel mhs) async {
    final db = await database;
    await db.update('mahasiswa', mhs.toMap(),
        where: 'nim = ?', whereArgs: [mhs.nim]);
  }
}
