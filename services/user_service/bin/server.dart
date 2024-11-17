import 'dart:convert';
import 'dart:io';


import 'package:collection/collection.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

import '../lib/user.dart';

final Router _router = Router()
  ..post('/register', _handleRegisterUser)
  ..post('/login', _handleLoginUser)
  ..get('/user', _handleGetUser);

Future<void> main() async {
  final HttpServer server = await serve(
    Pipeline().addMiddleware(logRequests()).addHandler(_router),
    InternetAddress.anyIPv4,
    int.parse(Platform.environment['PORT'] ?? '8080'),
  );

  print('UserService running on ${server.address.host}:${server.port}');
}

Future<Response> _handleRegisterUser(Request request) async {
  final String body = await request.readAsString();
  final Map<String, Object?> json = jsonDecode(body);

  if (json case {'username': String username, 'password': String password}) {
    final String userId = DateTime.now().millisecondsSinceEpoch.toString();

    usersById[userId] = User(userId: userId, username: username, password: password);

    return Response.ok(
      jsonEncode({'userId': userId}),
      headers: {'Content-Type': 'application/json'},
    );
  }

  return Response.badRequest(body: 'Invalid data format');
}

Future<Response> _handleLoginUser(Request request) async {
  final String body = await request.readAsString();
  final Map<String, Object?> json = jsonDecode(body);

  if (json case {'username': String username, 'password': String password}) {
    final User? user = usersById.values.firstWhereOrNull(
      (user) => user.username == username && user.password == password,
    );

    if (user == null) return Response.notFound('Invalid credentials');

    return Response.ok(
      jsonEncode({'userId': user.userId}),
      headers: {'Content-Type': 'application/json'},
    );
  }

  return Response.badRequest(body: 'Invalid data format');
}

Future<Response> _handleGetUser(Request request) async {
  final String? userId = request.url.queryParameters['userId'];

  if (userId == null) return Response.badRequest(body: 'Invalid data format');

  final User? user = usersById[userId];

  if (user == null) return Response.notFound('User not found');

  return Response.ok(
    jsonEncode(user),
    headers: {'Content-Type': 'application/json'},
  );
}
