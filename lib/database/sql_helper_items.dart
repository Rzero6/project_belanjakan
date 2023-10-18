import 'package:project_belanjakan/model/item.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelperItem {
  //create db
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""
      CREATE TABLE items(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      name TEXT,
      price INTEGER,
      detail TEXT,
      picture TEXT
      )
    """);
  }
  //call db
  static Future<sql.Database> db() async {
    return sql.openDatabase('items.db', version: 1,
    onCreate: (sql.Database database, int version) async {
      await createTables(database);
    });
  }

  //insert
  static Future<int> addItem(Item itemdata) async {
    final db = await SQLHelperItem.db();
    final data = {'name': itemdata.name, 'detail' : itemdata.detail, 'picture': itemdata.picture, 'price': itemdata.price};
    return await db.insert('items', data);
  }

  //read
  static Future<List<Map<String, dynamic>>> getItems(String search) async {
    final db = await SQLHelperItem.db();
    //return db.query('items', where: "id = $search%");
    return db.query('items', where: 'name LIKE ?', whereArgs: ['%$search%']);
  }

  //edit
  static Future<int> editItem(int id, Item itemdata) async {
    final db = await SQLHelperItem.db();
    final data = {'name': itemdata.name, 'detail' : itemdata.detail, 'picture': itemdata.picture, 'price': itemdata.price};
    return await db.update('items', data, where: "id = $id");
  }

  //delete
  static Future<int> deleteItem(int id) async {
    final db = await SQLHelperItem.db();
    return await db.delete('items', where: "id = $id");
  }

  //get an item
  static Future<Item?> getItemById(int id) async {
    final db = await SQLHelperItem.db();
    List<Map<String, dynamic>> result = await db.query('items', where: 'id = $id');
    if(result.isNotEmpty){
      Item itemData = Item(id: result.first['id'],name: result.first['name'],detail: result.first['detail'],picture: result.first['picture'],price: result.first['price']);
      return itemData;
    }else{
      return null;
    }
  }
  
}