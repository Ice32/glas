import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:glas_client/api/glas_import/dto/create_my_word_dto.dart';
import 'package:meta/meta.dart';

import '../../api/glas_http_client.dart';
import '../../api/glas_import/dto/my_word_dto.dart';

@immutable
class MyWordsService {
  final GlasHttpClient _httpClient = GetIt.instance.get<GlasHttpClient>();

  Future<void> createKnownWord(String text) async {
    final response = await _httpClient.post(
        'my-words', CreateMyWordDTO(text: text, isKnown: true).toJson());

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to create known word: ${response.reasonPhrase}');
    }
  }

  Future<List<MyWordDTO>> geMyWords() async {
    final response = await _httpClient.get('my-words');

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to retrieve my words: ${response.reasonPhrase}');
    }

    var rawList = jsonDecode(response.body) as List;
    return rawList.map((i) => MyWordDTO.fromJson(i)).toList();
  }
}
