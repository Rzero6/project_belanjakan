import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:project_belanjakan/model/coupon.dart';
import 'package:project_belanjakan/services/api/api_client.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CouponClient {
  static final ApiClient apiClient = ApiClient();
  static const String timeout = 'Take too long, check your connection';

  static Future<List<Coupon>> getCoupons(token) async {
    var client = http.Client();
    Uri uri = Uri.parse('${apiClient.baseUrl}/coupons');
    try {
      var response = await client.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 30));
      if (response.statusCode != 200) {
        throw json.decode(response.body)['message'].toString();
      }

      Iterable list = json.decode(response.body)['data'];
      return list.map((e) => Coupon.fromJson(e)).toList();
    } on TimeoutException catch (_) {
      return Future.error(timeout);
    } catch (e) {
      return Future.error(e.toString());
    } finally {
      client.close();
    }
  }

  static Future<Coupon> findCoupon(id, token) async {
    var client = http.Client();
    Uri uri = Uri.parse('${apiClient.baseUrl}/coupons/$id');
    try {
      var response = await client.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 30));
      if (response.statusCode != 200) throw Exception(response.reasonPhrase);
      return Coupon.fromJson(json.decode(response.body)['data']);
    } on TimeoutException catch (_) {
      return Future.error(timeout);
    } catch (e) {
      return Future.error(e.toString());
    } finally {
      client.close();
    }
  }

  static Future<Response> addCoupon(Coupon coupon, String token) async {
    var client = http.Client();
    Uri uri = Uri.parse('${apiClient.baseUrl}/coupons');
    try {
      var response = await client
          .post(
            uri,
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
            body: coupon.toRawJson(),
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

  static Future<Response> updateCoupon(
      Coupon updatedCoupon, String token) async {
    var client = http.Client();
    Uri uri = Uri.parse('${apiClient.baseUrl}/coupons/${updatedCoupon.id}');
    try {
      var response = await client
          .put(
            uri,
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
            body: updatedCoupon.toRawJson(),
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

  static Future<Response> deleteCoupon(int couponId) async {
    var client = http.Client();
    Uri uri = Uri.parse('${apiClient.baseUrl}/coupons/$couponId');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token')!;
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
