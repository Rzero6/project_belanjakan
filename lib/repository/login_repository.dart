import '../model/user.dart';
import 'package:project_belanjakan/database/sql_helper_user.dart';

class FailedLogin implements Exception {
  String errorMessage() {
    return "Login Failed";
  }
}

class LoginRepository {
  Future<User> login(String username, String password) async {
    List<Map<String, dynamic>> users = await SQLHelperUser.getUsers();
    User userData = User();

    await Future.delayed(const Duration(seconds: 3), () {
      if (username == '' || password == '') {
        throw 'Username or Password cannot be empty';
      } else {
        for (var user in users) {
          if (user['username'] == username && user['password'] == password) {
            userData = User(
                id: user['id'],
                username: user['username'],
                password: user['password'],
                email: user['email'],
                dateOfBirth: user['date_of_birth'],
                phone: user['phone'],
                profilePic: user['profile_pic']);
            break;
          }
        }
        if (userData.username == null) {
          throw FailedLogin();
        }
      }
    });
    return userData;
  }
}
