import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:test/test.dart';

void main() {
  group('PaymentService', () {
    const String port = '8083';
    const String host = 'http://0.0.0.0:$port';
    late final Process process;

    setUpAll(() async {
      process = await Process.start(
        'dart',
        ['run', 'bin/server.dart'],
        environment: {'PORT': port},
      );
      await process.stdout.first;
    });

    tearDownAll(() {
      process.kill();
    });

    test('/payment, post returns 200', () async {
      final http.Response response = await http.post(
        Uri.parse('$host/payment'),
        headers: {'Content-Type': 'application/json'},
        body: '{"userId": "12345678", "orderId": "87654321", "amount": 100.00}',
      );
      expect(response.statusCode, 200);
      expect(response.body, 'Payment processed successfully');
    });

    test('/payment, get returns 200', () async {
      final http.Response response = await http.get(
        Uri.parse('$host/payment?userId=12345678&orderId=87654321'),
      );
      expect(response.statusCode, 200);
      expect(response.body.contains('"userId":"12345678"'), isTrue);
      expect(response.body.contains('"orderId":"87654321"'), isTrue);
      expect(response.body.contains('"status":"paid"'), isTrue);
    });
  });
}
