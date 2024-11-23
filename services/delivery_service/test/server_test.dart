import 'dart:io';

import 'package:core/core.dart';
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
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': AuthToken.test$,
        },
        body: '{"address": "123 Main St"}',
      );

      expect(response.statusCode, 200);
      expect(response.body, 'Order created successfully');
    });

    test('/order, get returns 200', () async {
      final http.Response response = await http.get(
        Uri.parse('$host/order'),
        headers: <String, String>{
          'Authorization': AuthToken.test$,
        },
      );

      expect(response.statusCode, 200);
      expect(response.body.contains('"address":"123 Main St"'), isTrue);
    });

    test('/order, post returns 400 (address missing)', () async {
      final http.Response response = await http.post(
        Uri.parse('$host/order'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': AuthToken.test$,
        },
        body: '{}', // Missing "address"
      );

      expect(response.statusCode, 400);
      expect(response.body, 'Invalid data format');
    });
  });
}
