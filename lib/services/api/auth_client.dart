import 'package:project_belanjakan/model/user.dart';
import 'package:http/http.dart' as http;
import 'package:project_belanjakan/services/api/api_client.dart';
import 'dart:async';
import 'dart:convert';

class AuthClient {
  ApiClient apiClient = ApiClient();

  Future<String> registerUser(User user) async {
    var client = http.Client();
    Uri uri = Uri.parse('${apiClient.baseUrl}/register');

    try {
      var response = await client.post(
        uri,
        body: {
          'name': user.name,
          'email': user.email,
          'password': user.password,
          'phone': user.phone,
          'date_of_birth': user.dateOfBirth,
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return 'Register Success';
      } else {
        var json = response.body;
        var jsonData = jsonDecode(json);
        if (jsonData.containsKey('message')) {
          var messageData = jsonData['message'];
          if (messageData.containsKey('email')) {
            var emailErrors = messageData['email'];
            if (emailErrors.isNotEmpty) {
              var errorMessage = emailErrors[0];
              throw Exception(errorMessage);
            }
          }
        }
        throw Exception(jsonData['message'] ?? 'Register Failed');
      }
    } on TimeoutException catch (_) {
      throw Exception('Take too long, please check your connection');
    } finally {
      client.close();
    }
  }

  Future<User> loginUser(String email, String password) async {
    var client = http.Client();
    Uri uri = Uri.parse('${apiClient.baseUrl}/login');

    try {
      var response = await client.post(
        uri,
        body: {
          'email': email,
          'password': password,
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        var json = response.body;
        var jsonData = jsonDecode(json);

        var userJson = jsonData['user'];
        String token = jsonData['access_token'];
        User user = User.fromJson(userJson);
        user.token = token;
        return user;
      } else {
        var json = response.body;
        var jsonData = jsonDecode(json);
        throw (jsonData['message'] ?? 'Login Failed');
      }
    } on TimeoutException catch (_) {
      throw ('Take too long, please check your connection');
    } finally {
      client.close();
    }
  }
}
