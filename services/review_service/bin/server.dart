import 'dart:convert';
import 'dart:io';

import 'package:core/core.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

import '../lib/review.dart';

final Router _router = Router()
  ..get('/review', _handleReviewGetRequest)
  ..post('/review', _handleReviewPostRequest);

Future<void> main() async {
  final HttpServer server = await serve(
    Pipeline()
        .addMiddleware(logRequests())
        .addMiddleware(authRequests())
        .addHandler(_router),
    InternetAddress.anyIPv4,
    int.parse(Platform.environment['PORT'] ?? '8085'),
  );

  print('ReviewService running on ${server.address.host}:${server.port}');
}

Future<Response> _handleReviewGetRequest(Request request) async {
  final String? productId = request.url.queryParameters['productId'];

  if (productId == null) return Response.badRequest(body: 'Missing productId');

  final List<Review> reviews = reviewsByProductId[productId] ?? <Review>[];

  return Response.ok(
    jsonEncode(reviews),
    headers: {'Content-Type': 'application/json'},
  );
}

Future<Response> _handleReviewPostRequest(Request request) async {
  final String body = await request.readAsString();
  final Map<String, Object?> json = jsonDecode(body);

  if (json case {'productId': String productId, 'rating': int rating, 'comment': String comment}) {
    final Review review = Review(productId, rating, comment);

    reviewsByProductId.update(
      productId,
      (List<Review> reviews) => reviews..add(review),
      ifAbsent: () => <Review>[review],
    );

    return Response.ok('Review added successfully');
  }

  return Response.badRequest(body: 'Invalid data format');
}
