import 'package:project_belanjakan/model/user.dart';
import 'package:http/http.dart' as http;
import 'package:project_belanjakan/services/api/api_client.dart';
import 'dart:async';
import 'dart:convert';

class UserClient {
  ApiClient apiClient = ApiClient();

  Future<User> updateUser(User user, String token) async {
    var client = http.Client();
    Uri uri = Uri.parse('${apiClient.baseUrl}/user');
    try {
      var response = await client.put(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: {
          'name': user.name,
          'email': user.email,
          'phone': user.phone,
          'profile_picture': user.profilePicture,
          'password': user.password,
        },
      ).timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        var json = response.body;
        var jsonData = jsonDecode(json);
        var userJson = jsonData['data'];
        return User.fromJson(userJson);
      } else {
        var json = response.body;
        var jsonData = jsonDecode(json);
        throw (jsonData['message'] ?? 'Update Failed');
      }
    } on TimeoutException catch (_) {
      throw ('Take too long, please check your connection');
    } finally {
      client.close();
    }
  }

  Future<User> getUser(String token) async {
    var client = http.Client();
    Uri uri = Uri.parse('${apiClient.baseUrl}/user');
    try {
      var response = await client.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        var json = response.body;
        var jsonData = jsonDecode(json);
        var userJson = jsonData['data'];
        return User.fromJson(userJson);
      } else {
        var json = response.body;
        var jsonData = jsonDecode(json);
        throw Exception(jsonData['message'] ?? 'Getting Info Failed');
      }
    } on TimeoutException catch (_) {
      throw Exception('Take too long, please check your connection');
    } finally {
      client.close();
    }
  }
}
