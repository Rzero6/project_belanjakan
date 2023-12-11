import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:project_belanjakan/services/api/api_client.dart';
import 'package:http/http.dart' as http;
import 'package:project_belanjakan/model/review.dart';

class ReviewClient {
  static final ApiClient apiClient = ApiClient();
  static const String timeout = 'Take too long, check your connection';

  static Future<Reviews> getReviewsPerItem(idItem) async {
    var client = http.Client();
    Uri uri;
    try {
      uri = Uri.parse('${apiClient.baseUrl}/item/$idItem/reviews');
      var response = await client.get(uri).timeout(const Duration(seconds: 30));
      if (response.statusCode != 200) {
        throw json.decode(response.body)['message'].toString();
      }

      Iterable list = json.decode(response.body)['data'];
      double rating = json.decode(response.body)['rating'];
      List<Review> listReviews = list.map((e) => Review.fromJson(e)).toList();
      return Reviews(rating: rating, listReviews: listReviews);
    } on TimeoutException catch (_) {
      return Future.error(timeout);
    } catch (e) {
      return Future.error(e.toString());
    } finally {
      client.close();
    }
  }

  static Future<Review> findReview(id, token) async {
    var client = http.Client();
    Uri uri = Uri.parse('${apiClient.baseUrl}/reviews/$id');
    try {
      var response = await client.get(uri, headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      }).timeout(const Duration(seconds: 30));
      if (response.statusCode != 200) throw Exception(response.reasonPhrase);
      Review review = Review.fromJson(json.decode(response.body)['data']);
      return review;
    } on TimeoutException catch (_) {
      return Future.error(timeout);
    } catch (e) {
      return Future.error(e.toString());
    } finally {
      client.close();
    }
  }

  static Future<Response> addReview(Review review, String token) async {
    var client = http.Client();
    Uri uri = Uri.parse('${apiClient.baseUrl}/reviews');
    try {
      var response = await client
          .post(
            uri,
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
            body: review.toRawJson(),
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

  static Future<Response> updateReview(
      Review updatedReview, String token) async {
    var client = http.Client();
    Uri uri = Uri.parse('${apiClient.baseUrl}/reviews/${updatedReview.id}');
    try {
      var response = await client
          .put(
            uri,
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
            body: updatedReview.toRawJson(),
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

  static Future<Response> deleteReview(int reviewId, String token) async {
    var client = http.Client();
    Uri uri = Uri.parse('${apiClient.baseUrl}/reviews/$reviewId');

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
