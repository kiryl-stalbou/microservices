import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

import '../lib/payment.dart';

final Router _router = Router()
  ..get('/payment', _handleGetPayment)
  ..post('/payment', _handlePostPayment);

Future<void> main() async {
  final HttpServer server = await serve(
    Pipeline().addMiddleware(logRequests()).addHandler(_router),
    InternetAddress.anyIPv4,
    int.parse(Platform.environment['PORT'] ?? '8080'),
  );

  print('PaymentService running on ${server.address.host}:${server.port}');
}

Future<Response> _handleGetPayment(Request request) async {
  final String? userId = request.url.queryParameters['userId'];
  final String? orderId = request.url.queryParameters['orderId'];

  if (userId == null || orderId == null) {
    return Response.badRequest(body: 'Missing parameters');
  }

  final Payment? payment = paymentByUserId[userId]?.firstWhereOrNull(
    (payment) => payment.orderId == orderId,
  );

  if (payment == null) return Response.notFound('Payment not found');

  return Response.ok(
    jsonEncode(payment.toJson()),
    headers: {'Content-Type': 'application/json'},
  );
}

Future<Response> _handlePostPayment(Request request) async {
  final String body = await request.readAsString();
  final Map<String, Object?> json = jsonDecode(body);

  if (json case {'userId': String userId, 'orderId': String orderId, 'amount': double amount}) {
    final Payment payment = Payment(userId, orderId, amount);

    paymentByUserId.update(
      userId,
      (List<Payment> payments) => payments..add(payment),
      ifAbsent: () => <Payment>[payment],
    );

    return Response.ok('Payment processed successfully');
  }

  return Response.badRequest(body: 'Invalid data format');
}
