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

    test('/register, post returns 200', () async {
      final http.Response response = await http.post(
        Uri.parse('$host/register'),
        headers: {'Content-Type': 'application/json'},
        body: '{"username": "user1", "password": "pass1"}',
      );
      expect(response.statusCode, 200);
      expect(response.body.contains('"userId"'), isTrue);
    });

    test('/login, post returns 200', () async {
      final http.Response response = await http.post(
        Uri.parse('$host/login'),
        headers: {'Content-Type': 'application/json'},
        body: '{"username": "user1", "password": "pass1"}',
      );
      expect(response.statusCode, 200);
      expect(response.body.contains('"userId"'), isTrue);
    });

    test('/user, get returns 200', () async {
      final http.Response registerResponse = await http.post(
        Uri.parse('$host/register'),
        headers: {'Content-Type': 'application/json'},
        body: '{"username": "user1", "password": "pass1"}',
      );

      final String userId = jsonDecode(registerResponse.body)['userId'];

      final http.Response response = await http.get(
        Uri.parse('$host/user?userId=$userId'),
      );

      expect(response.statusCode, 200);
      expect(response.body.contains('"userId":"$userId"'), isTrue);
      expect(response.body.contains('"username":"user1"'), isTrue);
    });

    test('/login, post returns 404 (invalid credentials)', () async {
      final http.Response response = await http.post(
        Uri.parse('$host/login'),
        headers: {'Content-Type': 'application/json'},
        body: '{"username": "user2", "password": "pass2"}',
      );

      expect(response.statusCode, 404);
      expect(response.body, 'Invalid credentials');
    });

    test('/user, get returns 400 (userId missing)', () async {
      final http.Response response = await http.get(
        Uri.parse('$host/user'),
      );
      expect(response.statusCode, 400);
      expect(response.body, 'Invalid data format');
    });

    test('/user, get returns 404 (invalid userId)', () async {
      final http.Response response = await http.get(
        Uri.parse('$host/user?userId=nonexistentId'),
      );
      expect(response.statusCode, 404);
      expect(response.body, 'User not found');
    });
  });
}
