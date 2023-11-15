import 'dart:math';

import 'package:project_belanjakan/services/api/remote_service.dart';

import '../model/user_api.dart';

class FailedLogin implements Exception {
  String errorMessage() {
    return "Login Failed";
  }
}

class LoginRepository {
  RemoteService remoteService = RemoteService();

  Future<User> login(String email, String password) async {
    try {
      User userData = await remoteService.loginUser(email, password);
      return userData;
    } catch (e) {
      rethrow;
    }
  }
}
