import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:test/test.dart';

void main() {
  group('UserService', () {
    const String port = '8086';
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

    late final String authToken;

    test('/register, post returns 200', () async {
      final http.Response response = await http.post(
        Uri.parse('$host/register'),
        headers: {'Content-Type': 'application/json'},
        body: '{"username": "Jonh Doe", "password": "123"}',
      );

      authToken = jsonDecode(response.body)['auth_token'];

      expect(response.statusCode, 200);
      expect(response.body.contains('"auth_token":"$authToken"'), isTrue);
    });

    test('/login, post returns 200', () async {
      final http.Response response = await http.post(
        Uri.parse('$host/login'),
        headers: {'Content-Type': 'application/json'},
        body: '{"username": "Jonh Doe", "password": "123"}',
      );

      expect(response.statusCode, 200);
      expect(response.body.contains('"auth_token":"$authToken"'), isTrue);
    });

    test('/user, get returns 200', () async {
      final http.Response response = await http.get(
        Uri.parse('$host/user'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': authToken,
        },
      );

      expect(response.statusCode, 200);
      expect(response.body.contains('"username":"Jonh Doe"'), isTrue);
      expect(response.body.contains('"password":"123"'), isTrue);
    });

    test('/login, post returns 404 (invalid credentials)', () async {
      final http.Response response = await http.post(
        Uri.parse('$host/login'),
        headers: {'Content-Type': 'application/json'},
        body: '{"username": "123", "password": "123"}',
      );

      expect(response.statusCode, 404);
      expect(response.body, 'Invalid credentials');
    });
  });
}
