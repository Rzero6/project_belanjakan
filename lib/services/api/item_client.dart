import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:project_belanjakan/services/api/api_client.dart';
import 'package:http/http.dart' as http;
import 'package:project_belanjakan/model/item.dart';

class ItemClient {
  static final ApiClient apiClient = ApiClient();
  static const String timeout = 'Take too long, check your connection';

  static Future<List<Item>> getItems(String searchTerm) async {
    var client = http.Client();
    Uri uri;
    try {
      if (searchTerm.isEmpty) {
        uri = Uri.parse('${apiClient.baseUrl}/items');
      } else {
        uri = Uri.parse('${apiClient.baseUrl}/items/search/q=$searchTerm');
      }
      var response = await client.get(uri).timeout(const Duration(seconds: 30));
      if (response.statusCode != 200) {
        throw json.decode(response.body)['message'].toString();
      }

      Iterable list = json.decode(response.body)['data'];
      return list.map((e) => Item.fromJson(e)).toList();
    } on TimeoutException catch (_) {
      return Future.error(timeout);
    } catch (e) {
      return Future.error(e.toString());
    } finally {
      client.close();
    }
  }

  static Future<List<Item>> getItemsByCat(int searchTerm) async {
    var client = http.Client();
    Uri uri;
    try {
      uri = Uri.parse('${apiClient.baseUrl}/items/cat/$searchTerm');

      var response = await client.get(uri).timeout(const Duration(seconds: 30));
      if (response.statusCode != 200) {
        throw json.decode(response.body)['message'].toString();
      }

      Iterable list = json.decode(response.body)['data'];
      return list.map((e) => Item.fromJson(e)).toList();
    } on TimeoutException catch (_) {
      return Future.error(timeout);
    } catch (e) {
      return Future.error(e.toString());
    } finally {
      client.close();
    }
  }

  static Future<List<Item>> getItemsOnlyOwner(
      String searchTerm, String token) async {
    var client = http.Client();
    if (searchTerm.isEmpty) searchTerm = '';
    Uri uri = Uri.parse('${apiClient.baseUrl}/items/auth/search/q=$searchTerm');
    try {
      var response = await client.get(uri, headers: {
        'Authorization': 'Bearer $token',
      }).timeout(const Duration(seconds: 30));
      if (response.statusCode != 200) {
        throw json.decode(response.body)['message'].toString();
      }

      Iterable list = json.decode(response.body)['data'];
      return list.map((e) => Item.fromJson(e)).toList();
    } on TimeoutException catch (_) {
      return Future.error(timeout);
    } catch (e) {
      return Future.error(e.toString());
    } finally {
      client.close();
    }
  }

  static Future<Item> findItem(id) async {
    var client = http.Client();
    Uri uri = Uri.parse('${apiClient.baseUrl}/items/$id');
    try {
      var response = await client.get(uri).timeout(const Duration(seconds: 30));
      if (response.statusCode != 200) throw Exception(response.reasonPhrase);
      Item item = Item.fromJson(json.decode(response.body)['data']);
      return item;
    } on TimeoutException catch (_) {
      return Future.error(timeout);
    } catch (e) {
      return Future.error(e.toString());
    } finally {
      client.close();
    }
  }

  static Future<Response> addItem(Item item, String token) async {
    var client = http.Client();
    Uri uri = Uri.parse('${apiClient.baseUrl}/items');
    try {
      var response = await client
          .post(
            uri,
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
            body: item.toRawJson(),
          )
          .timeout(const Duration(seconds: 30));
      if (response.statusCode != 200) throw Exception(response.reasonPhrase);
      return response;
    } on TimeoutException catch (_) {
      return Future.error(timeout);
    } catch (e) {
      return Future.error(e.toString());
    } finally {
      client.close();
    }
  }

  static Future<Response> updateItem(Item updatedItem, String token) async {
    var client = http.Client();
    Uri uri = Uri.parse('${apiClient.baseUrl}/items/${updatedItem.id}');
    try {
      var response = await client
          .put(
            uri,
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
            body: updatedItem.toRawJson(),
          )
          .timeout(const Duration(seconds: 30));
      if (response.statusCode != 200) throw Exception(response.reasonPhrase);
      return response;
    } on TimeoutException catch (_) {
      return Future.error(timeout);
    } catch (e) {
      return Future.error(e.toString());
    } finally {
      client.close();
    }
  }

  static Future<Response> deleteItem(int itemId, String token) async {
    var client = http.Client();
    Uri uri = Uri.parse('${apiClient.baseUrl}/items/$itemId');

    try {
      var response = await client.delete(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 30));
      if (response.statusCode != 200) throw Exception(response.reasonPhrase);
      return response;
    } on TimeoutException catch (_) {
      return Future.error(timeout);
    } catch (e) {
      return Future.error(e.toString());
    } finally {
      client.close();
    }
  }

  static Future<Response> addItemTesting(Item item, String token) async {
    var client = http.Client();
    Uri uri = Uri.parse('http://127.0.0.1:8000/api/items');
    try {
      var response = await client
          .post(
            uri,
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
            body: item.toRawJson(),
          )
          .timeout(const Duration(seconds: 30));
      if (response.statusCode != 200) throw Exception(response.reasonPhrase);
      return response;
    } on TimeoutException catch (_) {
      return Future.error(timeout);
    } catch (e) {
      return Future.error(e.toString());
    } finally {
      client.close();
    }
  }

  static Future<Item> findItemTsting(id) async {
    var client = http.Client();
    Uri uri = Uri.parse('http://127.0.0.1:8000/api/items/$id');
    try {
      var response = await client.get(uri).timeout(const Duration(seconds: 30));
      if (response.statusCode != 200) throw Exception(response.reasonPhrase);
      Item item = Item.fromJson(json.decode(response.body)['data']);
      return item;
    } on TimeoutException catch (_) {
      return Future.error(timeout);
    } catch (e) {
      return Future.error(e.toString());
    } finally {
      client.close();
    }
  }

  static Future<Response> updateItemTesting(
      Item updatedItem, String token) async {
    var client = http.Client();
    Uri uri = Uri.parse('http://127.0.0.1:8000/api/items/${updatedItem.id}');
    try {
      var response = await client
          .put(
            uri,
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
            body: updatedItem.toRawJson(),
          )
          .timeout(const Duration(seconds: 30));
      if (response.statusCode != 200) throw Exception(response.reasonPhrase);
      return response;
    } on TimeoutException catch (_) {
      return Future.error(timeout);
    } catch (e) {
      return Future.error(e.toString());
    } finally {
      client.close();
    }
  }

  static Future<Response> deleteItemTesting(int itemId, String token) async {
    var client = http.Client();
    Uri uri = Uri.parse('http://127.0.0.1:8000/api/items/$itemId');

    try {
      var response = await client.delete(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 30));
      if (response.statusCode != 200) throw Exception(response.reasonPhrase);
      return response;
    } on TimeoutException catch (_) {
      return Future.error(timeout);
    } catch (e) {
      return Future.error(e.toString());
    } finally {
      client.close();
    }
  }
}
