import 'dart:io';

import 'package:core/core.dart';
import 'package:http/http.dart' as http;
import 'package:test/test.dart';

void main() {
  group('ProductService', () {
    const String port = '8084';
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

    test('/product, post returns 200', () async {
      final http.Response response = await http.post(
        Uri.parse('$host/product'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': AuthToken.test$,
        },
        body: '{"productId": "1", "name": "Product A", "price": 50.0}',
      );

      expect(response.statusCode, 200);
      expect(response.body, 'Product added successfully');
    });

    test('/product, get returns 200', () async {
      final http.Response response = await http.get(
        Uri.parse('$host/product?productId=1'),
        headers: <String, String>{
          'Authorization': AuthToken.test$,
        },
      );

      expect(response.statusCode, 200);
      expect(response.body.contains('"productId":"1"'), isTrue);
      expect(response.body.contains('"name":"Product A"'), isTrue);
      expect(response.body.contains('"price":50.0'), isTrue);
    });
  });
}
