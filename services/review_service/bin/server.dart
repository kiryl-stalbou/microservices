import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

import '../lib/review.dart';

final Router _router = Router()
  ..get('/review', _handleGetReview)
  ..post('/review', _handlePostReview);

Future<void> main() async {
  final HttpServer server = await serve(
    Pipeline().addMiddleware(logRequests()).addHandler(_router),
    InternetAddress.anyIPv4,
    int.parse(Platform.environment['PORT'] ?? '8080'),
  );

  print('ReviewService running on ${server.address.host}:${server.port}');
}

Future<Response> _handleGetReview(Request request) async {
  final String? productId = request.url.queryParameters['productId'];

  if (productId == null) return Response.badRequest(body: 'Missing productId');

  final List<Review> reviews = reviewsByProductId[productId] ?? <Review>[];

  return Response.ok(
    jsonEncode(reviews),
    headers: {'Content-Type': 'application/json'},
  );
}

Future<Response> _handlePostReview(Request request) async {
  final String body = await request.readAsString();
  final Map<String, Object?> json = jsonDecode(body);

  if (json case {'productId': String productId, 'userId': String userId, 'rating': int rating, 'comment': String comment}) {
    final Review review = Review(productId, userId, rating, comment);

    reviewsByProductId.update(
      productId,
      (List<Review> reviews) => reviews..add(review),
      ifAbsent: () => <Review>[review],
    );

    return Response.ok('Review added successfully');
  }

  return Response.badRequest(body: 'Invalid data format');
}
