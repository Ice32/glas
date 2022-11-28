import 'dart:convert';

import 'package:http/http.dart';
import 'package:logger/logger.dart';

class GlasHttpClient {
  static const host = "10.0.2.2";
  static const port = "8080";
  static const protocol = "http";
  static const baseUrl = "$protocol://$host:$port";
  final logger = Logger();

  Future<Response> post(String path, Map<String, String> body) {
    return Client().post(Uri.parse("$baseUrl/$path"),
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json; charset=UTF-8'});
  }

  Future<Response> get(String path, [Map<String, String> params = const {}]) {
    var uri = Uri.http("$host:$port", path, params);
    logger.d(uri);
    return Client().get(
      uri,
      headers: {'Accept': 'application/json; charset=UTF-8'},
    );
  }
}
