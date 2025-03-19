import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:qr_scan/models/scan_models.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbProvider {
  static Database? _database;
  static final DbProvider db = DbProvider._();
  DbProvider._();

  Future<Database> get database async {
    // ignore: prefer_conditional_assignment
    if (_database == null) _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'Scans.db');
    print(path);
    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        await db.execute('''CREATE TABLE Scans(
          id INTEGER PRIMARY KEY,
          tipos TEXT,
          valor TEXT
        )''');
      },
    );
  }

  Future<int> insertRawScan(ScanModel nouScan) async {
    final id = nouScan.id;
    final tipos = nouScan.tipos;
    final valor = nouScan.valor;
    final db = await database;

    final res = await db.rawInsert('''
      INSERT INTO Scans(id, tipos, valor)
      VALUES(?, ?, ?)
    ''', [id, tipos, valor]);
    return res;
  }

  Future<int> insertScan(ScanModel nouScan) async {
    final db = await database;
    final res = await db.insert('Scans', nouScan.toMap());
    print(res);
    return res;
  }

  Future<List<ScanModel>> getAllScans() async {
    final db = await database;
    final res = await db.query('Scans');
    return res.isNotEmpty ? res.map((e) => ScanModel.fromMap(e)).toList() : [];
  }

  Future<ScanModel?> getScanById(int id) async {
    final db = await database;
    final res = await db.query('Scans', where: 'id=?', whereArgs: [id]);
    if (res.isNotEmpty) {
      return ScanModel.fromMap(res.first);
    }
    return null;
  }

  Future<List<ScanModel>> getScanPerTipos(String tipos) async {
    final db = await database;
    final res = await db.query('Scans', where: 'tipos = ?', whereArgs: [tipos]);
    return res.isNotEmpty ? res.map((e) => ScanModel.fromMap(e)).toList() : [];
  }

  Future<int> updateScan(ScanModel nouScan) async {
    final db = await database;
    final res = await db.update('Scans', nouScan.toMap(),
        where: 'id=?', whereArgs: [nouScan.id]);
    return res;
  }

  Future<int> deleteAllScans() async {
    final db = await database;
    final res = await db.rawDelete('''DELETE FROM Scans''');
    return res;
  }

  Future<int> deleteId(int id) async {
    final db = await database;
    final res = await db.rawDelete('''DELETE FROM Scans WHERE id = ?''', [id]);
    return res;
  }
}
