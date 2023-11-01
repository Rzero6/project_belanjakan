import 'package:sqflite/sqflite.dart' as sql;
import 'package:project_belanjakan/model/user.dart';

class SQLHelperUser {
  //create db
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""
      CREATE TABLE users(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      username TEXT,
      password TEXT,
      email TEXT UNIQUE,
      phone TEXT,
      date_of_birth DATE,
      profile_pic TEXT)
    """);
  }

  //call db
  static Future<sql.Database> db() async {
    return sql.openDatabase('users.db', version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
    });
  }

  //insert
  static Future<int> addUsers(User userdata) async {
    final db = await SQLHelperUser.db();
    final data = {
      'username': userdata.username,
      'password': userdata.password,
      'email': userdata.email,
      'phone': userdata.phone,
      'date_of_birth': userdata.dateOfBirth
    };
    return await db.insert('users', data);
  }

  //read
  static Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await SQLHelperUser.db();
    return db.query('users');
  }

  //edit
  static Future<int> editUsers(int id, User userdata) async {
    final db = await SQLHelperUser.db();
    final data = {
      'username': userdata.username,
      'password': userdata.password,
      'email': userdata.email,
      'phone': userdata.phone,
      'date_of_birth': userdata.dateOfBirth,
      "profile_pic": userdata.profilePic,
    };
    return await db.update('users', data, where: "id = $id");
  }

  //delete
  static Future<int> deleteUsers(int id) async {
    final db = await SQLHelperUser.db();
    return await db.delete('users', where: "id = $id");
  }

  //get a user
  static Future<User?> getUserById(int id) async {
    final db = await SQLHelperUser.db();
    List<Map<String, dynamic>> result =
        await db.query('users', where: 'id = $id');
    if (result.isNotEmpty) {
      User userData = User(
          id: result.first['id'],
          username: result.first['username'],
          password: result.first['password'],
          email: result.first['email'],
          phone: result.first['phone'],
          dateOfBirth: result.first['date_of_birth'],
          profilePic: result.first['profile_pic']);
      return userData;
    } else {
      return null;
    }
  }
}
