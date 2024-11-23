import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:core/core.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

import '../lib/user.dart';

final Router _router = Router()
  ..post('/register', _handleRegisterUserPostRequest)
  ..post('/login', _handleLoginUserPostRequest)
  ..get('/user', _handleUserGetRequest);

Future<void> main() async {
  final HttpServer server = await serve(
    Pipeline()
        .addMiddleware(logRequests())
        .addMiddleware(authRequests())
        .addHandler(_router),
    InternetAddress.anyIPv4,
    int.parse(Platform.environment['PORT'] ?? '8086'),
  );

  print('UserService running on ${server.address.host}:${server.port}');
}

Future<Response> _handleRegisterUserPostRequest(Request request) async {
  final String body = await request.readAsString();
  final Map<String, Object?> json = jsonDecode(body);

  if (json case {'username': String username, 'password': String password}) {
    final String userId = (usersById.length + 1).toString();

    final User user = User(
      userId: userId,
      username: username,
      password: password,
    );

    usersById[userId] = user;

    final String authToken = AuthToken.create(user.toJson());

    return Response.ok(
      jsonEncode({'auth_token': authToken}),
      headers: {'Content-Type': 'application/json'},
    );
  }

  return Response.badRequest(body: 'Invalid data format');
}

Future<Response> _handleLoginUserPostRequest(Request request) async {
  final String body = await request.readAsString();
  final Map<String, Object?> json = jsonDecode(body);

  if (json case {'username': String username, 'password': String password}) {
    final User? user = usersById.values.firstWhereOrNull(
      (user) => user.username == username && user.password == password,
    );

    if (user == null) return Response.notFound('Invalid credentials');

    final String authToken = AuthToken.create(user.toJson());

    return Response.ok(
      jsonEncode({'auth_token': authToken}),
      headers: {'Content-Type': 'application/json'},
    );
  }

  return Response.badRequest(body: 'Invalid data format');
}

Future<Response> _handleUserGetRequest(Request request) async {
  final String userId = request.context['userId'] as String;

  final User? user = usersById[userId];

  if (user == null) return Response.notFound('User not found');

  return Response.ok(
    jsonEncode(user),
    headers: {'Content-Type': 'application/json'},
  );
}
