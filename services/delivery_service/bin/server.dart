import 'dart:convert';
import 'dart:io';

import 'package:core/core.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

import '../lib/order.dart';

final Router _router = Router()
  ..get('/order', _handleOrderGetRequest)
  ..post('/order', _handleOrderPostRequest);

Future<void> main() async {
  final HttpServer server = await serve(
    Pipeline()
        .addMiddleware(logRequests())
        .addMiddleware(authRequests())
        .addHandler(_router),
    InternetAddress.anyIPv4,
    int.parse(Platform.environment['PORT'] ?? '8082'),
  );

  print('DeliveryService running on ${server.address.host}:${server.port}');
}

Future<Response> _handleOrderGetRequest(Request request) async {
  final String userId = request.context['userId'] as String;

  final Order? order = orderByUserId[userId];

  if (order == null) return Response.notFound('Order not found');

  return Response.ok(
    jsonEncode(order),
    headers: {'Content-Type': 'application/json'},
  );
}

Future<Response> _handleOrderPostRequest(Request request) async {
  final String userId = request.context['userId'] as String;

  final String body = await request.readAsString();
  final Map<String, Object?> json = jsonDecode(body);

  if (json case {'address': String address}) {
    orderByUserId[userId] = Order(address);

    return Response.ok('Order created successfully');
  }

  return Response.badRequest(body: 'Invalid data format');
}
