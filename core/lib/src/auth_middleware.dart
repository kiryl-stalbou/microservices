import 'package:shelf/shelf.dart';

import 'auth_token.dart';

const List<String> _publicPaths = ['login', 'register'];

Middleware authRequests() {
  return (Handler innerHandler) {
    return (Request request) async {
      if (_publicPaths.contains(request.url.path)) return innerHandler(request);

      try {
        final String? token = request.headers['Authorization'];

        if (token == null) return Response.forbidden('Missing auth header.');

        final Map<String, Object?>? payload = AuthToken.verify(token);

        if (payload == null) return Response.forbidden('Invalid auth token.');

        return innerHandler(request.change(context: payload));
      } catch (_) {
        return Response.badRequest(body: 'Invalid auth token format.');
      }
    };
  };
}
