import 'dart:convert';

import 'package:http/http.dart';
import 'package:logger/logger.dart';

class GlasHttpClient {
  static const host = "23f3-77-238-217-37.eu.ngrok.io";
  static const protocol = "https";
  static const baseUrl = "$protocol://$host";
  final logger = Logger();

  Future<Response> post(String path, Map<String, dynamic> body) {
    return Client().post(Uri.parse("$baseUrl/$path"),
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json; charset=UTF-8'});
  }

  Future<Response> get(String path, [Map<String, String> params = const {}]) {
    var uri = protocol == 'http'
        ? Uri.http(host, path, params)
        : Uri.https(host, path, params);
    logger.d(uri);
    return Client().get(
      uri,
      headers: {'Accept': 'application/json; charset=UTF-8'},
    );
  }
}
