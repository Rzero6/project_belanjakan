import 'dart:async';
import 'dart:convert';

import 'package:project_belanjakan/model/item_api.dart';
import 'package:http/http.dart' as http;
import 'package:project_belanjakan/model/user_api.dart';

class RemoteService {
  final String domainName = '192.168.1.8';
  late final String baseUrl;

  RemoteService() {
    baseUrl = 'http://$domainName:8000/api';
  }

  Future<String> registerUser(User user) async {
    var client = http.Client();
    Uri uri = Uri.parse('$baseUrl/register');

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
    Uri uri = Uri.parse('$baseUrl/login');

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

  Future<User> updateUser(User user, String token) async {
    var client = http.Client();
    Uri uri = Uri.parse('$baseUrl/user');
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
    Uri uri = Uri.parse('$baseUrl/user');
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

  Future<List<Item>?> getItems(String searchTerm) async {
    var client = http.Client();
    Uri uri;
    try {
      if (searchTerm.isEmpty) {
        uri = Uri.parse('$baseUrl/items');
      } else {
        uri = Uri.parse('$baseUrl/items/search/q={$searchTerm}');
      }
      var response = await client.get(uri).timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) {
        var json = response.body;
        var jsonData = jsonDecode(json);

        var itemsData = jsonData['data'];

        List<Item> items = (itemsData as List<dynamic>)
            .map((itemJson) => Item.fromJson(itemJson))
            .toList();
        return items;
      }
    } on TimeoutException catch (_) {
      throw Exception('Take too long, please check your connection');
    } finally {
      client.close();
    }
    return null;
  }

  Future<bool> addItem(Item item, String token) async {
    var client = http.Client();
    Uri uri = Uri.parse('$baseUrl/items');

    try {
      var response = await client.post(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: {
          'name': item.name,
          'detail': item.detail,
          'image': item.image,
          'price': item.price,
          'stock': item.stock,
        },
      );
      return response.statusCode == 200;
    } finally {
      client.close();
    }
  }

  Future<bool> updateItem(int itemId, Item updatedItem, String token) async {
    var client = http.Client();
    Uri uri = Uri.parse('$baseUrl/items/$itemId');

    try {
      var response = await client.put(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: {
          'name': updatedItem.name,
          'detail': updatedItem.detail,
          'image': updatedItem.image,
          'price': updatedItem.price,
          'stock': updatedItem.stock,
        },
      );

      return response.statusCode == 200;
    } finally {
      client.close();
    }
  }

  Future<bool> deleteItem(int itemId, String token) async {
    var client = http.Client();
    Uri uri = Uri.parse(
        '$baseUrl/items/$itemId');

    try {
      var response = await client.delete(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      return response.statusCode == 200;
    } finally {
      client.close();
    }
  }
}
