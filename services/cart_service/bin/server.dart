import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

import '../lib/cart.dart';

final Router _router = Router()
  ..get('/cart', _handleCartGetRequest)
  ..post('/cart', _handleCartPostRequest);

Future<void> main() async {
  final HttpServer server = await serve(
    Pipeline().addMiddleware(logRequests()).addHandler(_router),
    InternetAddress.anyIPv4,
    int.parse(Platform.environment['PORT'] ?? '8080'),
  );

  print('CartService running on ${server.address.host}:${server.port}');
}

Future<Response> _handleCartGetRequest(Request request) async {
  final String? userId = request.url.queryParameters['userId'];

  if (userId == null) return Response.badRequest(body: 'User not found');

  final List<CartItem> items = cartByUserId[userId]?.items ?? <CartItem>[];

  return Response.ok(
    jsonEncode(items),
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
  );
}

Future<Response> _handleCartPostRequest(Request request) async {
  final String body = await request.readAsString();
  final Map<String, Object?> json = jsonDecode(body);

  if (json case {'userId': String userId, 'productId': String productId, 'quantity': int quantity}) {
    final CartItem item = CartItem(productId, quantity);

    cartByUserId.update(
      userId,
      (Cart cart) => cart..items.add(item),
      ifAbsent: () => Cart(<CartItem>[item]),
    );

    return Response.ok('Product added to cart');
  }

  return Response.badRequest(body: 'Invalid data format');
}
