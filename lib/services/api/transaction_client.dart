import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:project_belanjakan/model/transaction.dart';
import 'package:project_belanjakan/services/api/api_client.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TransactionClient {
  static final ApiClient apiClient = ApiClient();
  static const String timeout = 'Take too long, check your connection';

  static Future<List<Transaction>> getTransactionsPerUser() async {
    var client = http.Client();
    Uri uri;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token')!;

    try {
      uri = Uri.parse('${apiClient.baseUrl}/transactions');
      var response = await client.get(uri, headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      }).timeout(const Duration(seconds: 30));
      if (response.statusCode != 200) {
        throw json.decode(response.body)['message'].toString();
      }
      Iterable list = json.decode(response.body)['data'];
      return list.map((e) => Transaction.fromJson(e)).toList();
    } on TimeoutException catch (_) {
      return Future.error(timeout);
    } catch (e) {
      return Future.error(e.toString());
    } finally {
      client.close();
    }
  }

  static Future<List<DetailTransaction>> getDetailsTransactionsPerTransaction(
      int idTransaction, String token) async {
    var client = http.Client();
    Uri uri;

    try {
      uri =
          Uri.parse('${apiClient.baseUrl}/transactions/$idTransaction/details');
      var response = await client.get(uri, headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      }).timeout(const Duration(seconds: 30));
      if (response.statusCode != 200) {
        throw json.decode(response.body)['message'].toString();
      }

      Iterable list = json.decode(response.body)['data'];
      return list.map((e) => DetailTransaction.fromJson(e)).toList();
    } on TimeoutException catch (_) {
      return Future.error(timeout);
    } catch (e) {
      return Future.error(e.toString());
    } finally {
      client.close();
    }
  }

  static Future<Transaction> findTransaction(id) async {
    var client = http.Client();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token')!;

    Uri uri = Uri.parse('${apiClient.baseUrl}/transactions/$id');
    try {
      var response = await client.get(uri, headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      }).timeout(const Duration(seconds: 30));
      if (response.statusCode != 200) throw Exception(response.reasonPhrase);
      Transaction transaction =
          Transaction.fromJson(json.decode(response.body)['data']);
      List<DetailTransaction> listDetails =
          await getDetailsTransactionsPerTransaction(id, token);
      transaction.listDetails = listDetails;
      return transaction;
    } on TimeoutException catch (_) {
      return Future.error(timeout);
    } catch (e) {
      return Future.error(e.toString());
    } finally {
      client.close();
    }
  }

  static Future<int> addTransaction(Transaction transaction) async {
    var client = http.Client();
    Uri uri = Uri.parse('${apiClient.baseUrl}/transactions');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token')!;
    try {
      var response = await client
          .post(
            uri,
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
            body: transaction.toRawJson(),
          )
          .timeout(const Duration(seconds: 30));
      if (response.statusCode != 200) throw Exception(response.reasonPhrase);
      var responseData = json.decode(response.body);
      return responseData['data']['id'];
    } on TimeoutException catch (_) {
      return Future.error(timeout);
    } catch (e) {
      return Future.error(e.toString());
    } finally {
      client.close();
    }
  }

  static Future<Response> addDetailsTransaction(
      DetailTransaction detailTransaction) async {
    var client = http.Client();
    Uri uri = Uri.parse('${apiClient.baseUrl}/transactions/details');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token')!;
    try {
      var response = await client
          .post(
            uri,
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
            body: detailTransaction.toRawJson(),
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

  static Future<Response> updateRatedDetailsTransaction(
      int idDetailTransaksi) async {
    var client = http.Client();
    Uri uri = Uri.parse(
        '${apiClient.baseUrl}/transactions/details/$idDetailTransaksi');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token')!;
    try {
      var response = await client.patch(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
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
