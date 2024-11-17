import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:test/test.dart';

void main() {
  group('DeliveryService', () {
    const String port = '8082';
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

    test('/order, post returns 200', () async {
      final http.Response response = await http.post(
        Uri.parse('$host/order'),
        headers: {'Content-Type': 'application/json'},
        body: '{"userId": "12345678", "address": "123 Main St"}',
      );
      expect(response.statusCode, 200);
      expect(response.body, 'Order created successfully');
    });

    test('/order, get returns 200', () async {
      final http.Response response = await http.get(
        Uri.parse('$host/order?userId=12345678'),
      );
      expect(response.statusCode, 200);
      expect(response.body.contains('"userId":"12345678"'), isTrue);
      expect(response.body.contains('"address":"123 Main St"'), isTrue);
    });

    test('/order, get returns 400 (userId missing)', () async {
      final http.Response response = await http.get(
        Uri.parse('$host/order'),
      );
      expect(response.statusCode, 400);
      expect(response.body, 'User not found');
    });

    test('/order, post returns 400 (address missing)', () async {
      final http.Response response = await http.post(
        Uri.parse('$host/order'),
        headers: {'Content-Type': 'application/json'},
        body: '{"userId": "12345678"}', // Missing "address"
      );
      expect(response.statusCode, 400);
      expect(response.body, 'Invalid data format');
    });
  });
}
