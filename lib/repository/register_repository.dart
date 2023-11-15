import 'package:project_belanjakan/model/user_api.dart';
import 'package:project_belanjakan/services/api/remote_service.dart';

class FailedRegister implements Exception {
  String errorMessage() {
    return "Register Failed";
  }
}

class RegisterRepository {
  RemoteService remoteService = RemoteService();

  Future<User> register(String username, String password, String phone,
      String date, String email) async {
    User userData = User(
        name: username,
        password: password,
        phone: phone,
        dateOfBirth: date,
        email: email);
    try {
      String message = await remoteService.registerUser(userData);
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
