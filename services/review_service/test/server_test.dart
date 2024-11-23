import 'dart:io';

import 'package:core/core.dart';
import 'package:http/http.dart' as http;
import 'package:test/test.dart';

void main() {
  group('ReviewService', () {
    const String port = '8085';
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

    test('/review, post returns 200', () async {
      final http.Response response = await http.post(
        Uri.parse('$host/review'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': AuthToken.test$,
        },
        body: '{"productId": "1", "rating": 4, "comment": "Great product!"}',
      );

      expect(response.statusCode, 200);
      expect(response.body, 'Review added successfully');
    });

    test('/review, get returns 200', () async {
      final http.Response response = await http.get(
        Uri.parse('$host/review?productId=1'),
        headers: <String, String>{
          'Authorization': AuthToken.test$,
        },
      );

      expect(response.statusCode, 200);
      expect(response.body.contains('"productId":"1"'), isTrue);
      expect(response.body.contains('"rating":4'), isTrue);
      expect(response.body.contains('"comment":"Great product!"'), isTrue);
    });
  });
}
