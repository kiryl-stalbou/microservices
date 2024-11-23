import 'dart:convert';
import 'dart:io';

import 'package:core/core.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

import '../lib/product.dart';

final Router _router = Router()
  ..get('/product', _handleProductGetRequest)
  ..post('/product', _handleProductPostRequest);

Future<void> main() async {
  final HttpServer server = await serve(
    Pipeline()
        .addMiddleware(logRequests())
        .addMiddleware(authRequests())
        .addHandler(_router),
    InternetAddress.anyIPv4,
    int.parse(Platform.environment['PORT'] ?? '8084'),
  );

  print('ProductService running on ${server.address.host}:${server.port}');
}

Future<Response> _handleProductGetRequest(Request request) async {
  final String? productId = request.url.queryParameters['productId'];

  if (productId == null) return Response.badRequest(body: 'Missing productId');

  final Product? product = productById[productId];

  if (product == null) return Response.notFound('Product not found');

  return Response.ok(
    jsonEncode(product),
    headers: {'Content-Type': 'application/json'},
  );
}

Future<Response> _handleProductPostRequest(Request request) async {
  final String body = await request.readAsString();
  final Map<String, Object?> json = jsonDecode(body);

  if (json case {'productId': String productId, 'name': String name, 'price': double price}) {
    productById[productId] = Product(productId, name, price);

    return Response.ok('Product added successfully');
  }

  return Response.badRequest(body: 'Invalid data format');
}
