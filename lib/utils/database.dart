import 'package:done_app/models/alarm_body.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DBHelper {
  static Database _db;
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDatabase();
    return _db;
  }

  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'alarm.db');
    var db = await openDatabase(path, version: 2, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db
        .execute('CREATE TABLE alarm (id INTEGER PRIMARY KEY AUTOINCREMENT, time TEXT, date INTEGER, description TEXT, privacy TEXT, file_url BLOB)');
  }

  Future<AlarmBody> add(AlarmBody item) async {
    var dbClient = await db;
    item.id = await dbClient.insert('alarm', item.toJson());
    return item;
  }

  Future<List<AlarmBody>> getproducts() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query('alarm', columns: ['id', 'time','date','description','privacy','file_url']);
    List<AlarmBody> products = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        products.add(AlarmBody.fromJson(maps[i]));
      }
    }
    return products;
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.delete(
      'alarm',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> update(AlarmBody product) async {
    var dbClient = await db;
    return await dbClient.update(
      'alarm',
      product.toJson(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}    