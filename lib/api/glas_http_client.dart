import 'dart:convert';

import 'package:http/http.dart';

class GlasHttpClient {
  static const baseUrl = "http://localhost:8080";

  Future<Response> post(String path, Map<String, String> body) {
    return Client().post(Uri.parse("$baseUrl/$path"),
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json; charset=UTF-8'});
  }

  Future<Response> get(String path) {
    return Client().get(Uri.parse("$baseUrl/$path"),
        headers: {'Content-Type': 'application/json; charset=UTF-8'});
  }
}