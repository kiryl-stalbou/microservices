import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:test/test.dart';

void main() {
  group('CartService', () {
    const String port = '8081';
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

    test('/cart, post returns 200', () async {
      final http.Response response = await http.post(
        Uri.parse('$host/cart'),
        headers: {'Content-Type': 'application/json'},
        body: '{"userId": "12345678", "productId": "1", "quantity": 2}',
      );
      expect(response.statusCode, 200);
      expect(response.body, 'Product added to cart');
    });

    test('/cart, get returns 200', () async {
      final http.Response response = await http.get(
        Uri.parse('$host/cart?userId=12345678'),
      );
      expect(response.statusCode, 200);
      expect(response.body.contains('"productId":"1"'), isTrue);
      expect(response.body.contains('"quantity":2'), isTrue);
    });

    test('/cart, get returns 400 (userId missing)', () async {
      final http.Response response = await http.get(
        Uri.parse('$host/cart'),
      );
      expect(response.statusCode, 400);
      expect(response.body, 'User not found');
    });

    test('/cart, post returns 400 (productId missing)', () async {
      final http.Response response = await http.post(
        Uri.parse('$host/cart'),
        headers: {'Content-Type': 'application/json'},
        body: '{"userId": "12345678", "quantity": 2}', // Missing "productId"
      );
      expect(response.statusCode, 400);
      expect(response.body, 'Invalid data format');
    });

    test('/cart, post returns 400 (quantity missing)', () async {
      final http.Response response = await http.post(
        Uri.parse('$host/cart'),
        headers: {'Content-Type': 'application/json'},
        body: '{"userId": "12345678", "productId": "1"}', // Missing "quantity"
      );
      expect(response.statusCode, 400);
      expect(response.body, 'Invalid data format');
    });
  });
}
