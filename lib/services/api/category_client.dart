import 'dart:async';
import 'dart:convert';
import 'package:project_belanjakan/model/category.dart';
import 'package:project_belanjakan/services/api/api_client.dart';
import 'package:http/http.dart' as http;

class CategoryClient {
  static final ApiClient apiClient = ApiClient();
  static const String timeout = 'Take too long, check your connection';

  static Future<List<Category>> getCategories() async {
    var client = http.Client();
    Uri uri = Uri.parse('${apiClient.baseUrl}/categories');
    try {
      var response = await client
          .get(
            uri,
          )
          .timeout(const Duration(seconds: 30));
      if (response.statusCode != 200) {
        throw json.decode(response.body)['message'].toString();
      }

      Iterable list = json.decode(response.body)['data'];
      return list.map((e) => Category.fromJson(e)).toList();
    } on TimeoutException catch (_) {
      return Future.error(timeout);
    } catch (e) {
      return Future.error(e.toString());
    } finally {
      client.close();
    }
  }
}
