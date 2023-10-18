import 'package:sqflite/sqflite.dart';

import '../model/user.dart';
import 'package:project_belanjakan/database/sql_helper_user.dart';

class FailedRegister implements Exception {
  String errorMessage() {
    return "Register Failed";
  }
}

class RegisterRepository {
  User userData = User();
  Future<User> register(String username, String password, String phone,
      String date, String email) async {
    await Future.delayed(const Duration(seconds: 3), () async {
      if (username == '' ||
          password == '' ||
          phone == '' ||
          date == '' ||
          email == '') {
        throw 'Field Must not be empty';
      } else if (!email.contains("@")) {
        throw 'Email Must contain @';
      } else if (username != '' &&
          password != '' &&
          phone != '' &&
          date != '' &&
          email != '' &&
          email.contains('@')) {
        userData = User(
            username: username,
            password: password,
            dateOfBirth: date,
            email: email,
            phone: phone);
        try {
          await SQLHelperUser.addUsers(userData);
        } on DatabaseException catch (e) {
          if (e.isUniqueConstraintError()) {
            throw 'Email already registered';
          } else {
            throw FailedRegister();
          }
        }
      } else {
        throw FailedRegister();
      }
    });
    return userData;
  }
}
