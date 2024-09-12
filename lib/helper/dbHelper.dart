import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _database;

  var tableName = "prayertime";

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await open();
    return _database;
  }

  open() async {
    var documentDir = await getApplicationDocumentsDirectory();
    var path = join(documentDir.path, "a1.db");
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  _onCreate(Database db, version) async {
    return await db.execute('''
        create table $tableName 
        (ID INTEGER PRIMARY KEY, MONTH	VARCHAR(512), DATE	VARCHAR(512), FAJR	VARCHAR(512), 
        DUHUR	VARCHAR(512), ASR	VARCHAR(512), MAGHRIB	VARCHAR(512), ISHA	VARCHAR(512));
        ''');
  }

  insert(data) async {
    Database? db = await database;
    return db?.insert(tableName, data);
  }

  query() async {
    Database? db = await database;
    return await db?.query(tableName);
  }

  rawQuery(query) async {
    Database? db = await database;
    return db?.rawQuery(query);
  }

  deleteAll() async {
    Database? db = await database;
    return db?.rawDelete("delete from $tableName");
  }

  Future<void> batch(data) async {
    Database? db = await database;
    Batch batch = db!.batch();
    for (var item in data) {
      batch.insert(tableName, item);
    }
    await batch.commit(noResult: true);
  }
}
