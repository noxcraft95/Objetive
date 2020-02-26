import 'dart:async';
import 'dart:io';

import 'package:objetive/models/nodo_item.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static const String tableName = "table_objetivo";
  static const String columnId = "id";
  static const String columnTitulo = "titulo";
  static const String columnDescripcion = "descripcion";
  static const String columnPlanAccion = "plan_accion";
  static const String columnFechaCreacion = "fecha_creacion";
  static const String columnFechaRealizar = "fecha_realizar";
  static const String columnRealizado = "realizado";

  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;
  static Database _db;

  Future<Database> get getDb async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "objetive.db");
    var dbCreated = await openDatabase(path, version: 1, onCreate: _onCreate);
    return dbCreated;
  }

  void _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE $tableName("
        "$columnId INTEGER PRIMARY KEY, "
        "$columnTitulo TEXT NOT NULL, "
        "$columnDescripcion TEXT, "
        "$columnPlanAccion TEXT, "
        "$columnFechaCreacion TEXT NOT NULL,"
        "$columnFechaRealizar TEXT,"
        "$columnRealizado TEXT );");
  }


  Future<int> saveItem(ItemObjetivo item) async {
    var dbClient = await getDb;
    int rowsSaved = await dbClient.insert(tableName, item.toMap());
    return rowsSaved;
  }

  Future<List> getItems() async {
    var dbClient = await getDb;
    var result = await dbClient.rawQuery("SELECT * FROM $tableName");
    return result.toList();
  }

  Future<int> getCount() async {
    var dbClient = await getDb;
    return Sqflite.firstIntValue(
        await dbClient.rawQuery("SELECT COUNT (*) FROM $tableName"));
  }

  Future<ItemObjetivo> getItem(int itemId) async {
    var dbClient = await getDb;
    var item = await dbClient
        .rawQuery("SELECT * FROM ${tableName} WHERE $columnId=$itemId");
    if (item.length == 0) return null;
    return new ItemObjetivo.fromMap(item.first);
  }

  Future<int> deleteItem(int id) async {
    var db = await getDb;
    int rowsDeleted =
        await db.delete(tableName, where: "$columnId = ?", whereArgs: [id]);
    return rowsDeleted;
  }

  Future<int> updateItem(ItemObjetivo item) async {
    int id = item.id;
    print("id of the item is $id");
    var db = await getDb;
    int rowsUpdated = await db.update("$tableName", item.toMap(),
        where: "$columnId  = ?", whereArgs: [item.id]);
    return rowsUpdated;
  }

  Future close() async {
    var dbClient = await getDb;
    dbClient.close();
  }
}
