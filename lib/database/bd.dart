import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SqlDb {
  static Future<void> createTables(sql.Database database) async {
    await database.execute(""" CREATE TABLE tutorial(
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    title TEXT,
    description TEXT,
    createdAT TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    )
    """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'dbteste.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  //Insert
  static Future<int> insert(String title, String? description) async {
    final db = await SqlDb.db();

    final data = {'title': title, 'description': description};
    final id = await db.insert('items', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  //Mostra todos intens
  static Future<List<Map<String, dynamic>>> buscarTodos() async {
    final db = await SqlDb.db();
    return db.query('items', orderBy: "id");
  }

//Busca por item
  static Future<List<Map<String, dynamic>>> buscaPorItem(int id) async {
    final db = await SqlDb.db();
    return db.query('items', where: "id = ?", whereArgs: [id], limit: 1);
  }
  //Update
static Future<int> atualizaItem(
    int id, String title, String? descrption) async{
    final db = await SqlDb.db();

    final data = {
      'title': title,
      'description': descrption,
      'createdAt': DateTime.now().toString()
    };
    final result =
    await db.update('items', data, where: "id = ?", whereArgs: [id]);
    return result;
 }
  //delete
  static Future<void> deletItem(int id) async{
    final db = await SqlDb.db();

    try {
      await db.delete("items", where: "id = ?", whereArgs: [id]);
    }catch(err){
    debugPrint("Algo deu errado na exclusão do item: $err");
    }
  }
}
