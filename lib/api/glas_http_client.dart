import 'dart:convert';

import 'package:http/http.dart';

class GlasHttpClient {
  Future<Response> post(String path, Map<String, String> body) {
    return Client().post(Uri.parse("http://loocalhost:8080/$path"),
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json; charset=UTF-8'});
  }
}
