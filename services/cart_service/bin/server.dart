import 'dart:convert';
import 'dart:io';

import 'package:core/core.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

import '../lib/cart.dart';

final Router _router = Router()
  ..get('/cart', _handleCartGetRequest)
  ..post('/cart', _handleCartPostRequest);

Future<void> main() async {
  final HttpServer server = await serve(
    Pipeline()
        .addMiddleware(logRequests())
        .addMiddleware(authRequests())
        .addHandler(_router),
    InternetAddress.anyIPv4,
    int.parse(Platform.environment['PORT'] ?? '8081'),
  );

  print('CartService running on ${server.address.host}:${server.port}');
}

Future<Response> _handleCartGetRequest(Request request) async {
  final String userId = request.context['userId'] as String;

  final Cart cart = cartByUserId[userId] ??= Cart.empty();

  return Response.ok(
    jsonEncode(cart.items),
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
  );
}

Future<Response> _handleCartPostRequest(Request request) async {
  final String userId = request.context['userId'] as String;

  final String body = await request.readAsString();
  final Map<String, Object?> json = jsonDecode(body);

  if (json case {'productId': String productId, 'quantity': int quantity}) {
    final CartItem item = CartItem(productId, quantity);

    cartByUserId.update(
      userId,
      (Cart cart) => cart..items.add(item),
      ifAbsent: () => Cart(<CartItem>[item]),
    );

    return Response.ok('Products added to cart');
  }

  return Response.badRequest(body: 'Invalid data format');
}
