import 'package:project_belanjakan/model/user.dart';
import 'package:project_belanjakan/services/api/auth_client.dart';

class FailedRegister implements Exception {
  String errorMessage() {
    return "Register Failed";
  }
}

class RegisterRepository {
  AuthClient authClient = AuthClient();

  Future<User> register(String username, String password, String phone,
      String date, String email) async {
    User userData = User(
        name: username,
        password: password,
        phone: phone,
        dateOfBirth: date,
        email: email);
    try {
      String message = await authClient.registerUser(userData);
      if (message == 'Register Success') {
        return userData;
      }
      userData.name = message;
      return userData;
    } catch (e) {
      rethrow;
    }
  }
}
