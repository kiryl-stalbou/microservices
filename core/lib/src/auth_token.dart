import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:meta/meta.dart';

abstract final class AuthToken {
  static const String _secret = '2b7e151628aed2a6abf7158809cf4f3c';

  @visibleForTesting
  static const String test$ =
      'eyJ1c2VySWQiOiItMSJ9LlowMUl3dHg1cnlJc3RJUFBpeGY0UUdHcEw0QUcwbFpoeVN1bFNQWTBCSjA9';

  static String create(Map<String, Object?> json) {
    final String payload = jsonEncode(json);
    final String signature = _signatureOf(payload);
    final String token = '$payload.$signature';

    return base64Url.encode(token.codeUnits);
  }

  static Map<String, Object?>? verify(String tokenBase64) {
    final String token = String.fromCharCodes(base64Url.decode(tokenBase64));
    final [String payload, String signature] = token.split('.');

    if (signature != _signatureOf(payload)) return null;

    return jsonDecode(payload) as Map<String, Object?>;
  }

  static String _signatureOf(String payload) {
    final Hmac hmac = Hmac(sha256, _secret.codeUnits);
    final Digest digest = hmac.convert(payload.codeUnits);

    return base64Url.encode(digest.bytes);
  }
}
