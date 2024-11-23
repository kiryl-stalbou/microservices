import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:core/core.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

import '../lib/payment.dart';

final Router _router = Router()
  ..get('/payment', _handlePaymentGetRequest)
  ..post('/payment', _handlePaymentPostRequest);

Future<void> main() async {
  final HttpServer server = await serve(
    Pipeline()
        .addMiddleware(logRequests())
        .addMiddleware(authRequests())
        .addHandler(_router),
    InternetAddress.anyIPv4,
    int.parse(Platform.environment['PORT'] ?? '8083'),
  );

  print('PaymentService running on ${server.address.host}:${server.port}');
}

Future<Response> _handlePaymentGetRequest(Request request) async {
  final String userId = request.context['userId'] as String;
  final String? orderId = request.url.queryParameters['orderId'];

  if (orderId == null) return Response.badRequest(body: 'Missing orderId');

  final Payment? payment = paymentsByUserId[userId]?.firstWhereOrNull(
    (payment) => payment.orderId == orderId,
  );

  if (payment == null) return Response.notFound('Payment not found');

  return Response.ok(
    jsonEncode(payment),
    headers: {'Content-Type': 'application/json'},
  );
}

Future<Response> _handlePaymentPostRequest(Request request) async {
  final String userId = request.context['userId'] as String;

  final String body = await request.readAsString();
  final Map<String, Object?> json = jsonDecode(body);

  if (json case {'orderId': String orderId, 'amount': double amount}) {
    final Payment payment = Payment(orderId, amount);

    paymentsByUserId.update(
      userId,
      (List<Payment> payments) => payments..add(payment),
      ifAbsent: () => <Payment>[payment],
    );

    return Response.ok('Payment processed successfully');
  }

  return Response.badRequest(body: 'Invalid data format');
}
