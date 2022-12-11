import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:glas_client/api/glas_import/dto/create_known_word_dto.dart';
import 'package:meta/meta.dart';

import '../../api/glas_http_client.dart';
import '../../api/glas_import/dto/known_word_dto.dart';

@immutable
class KnownWordsService {
  final GlasHttpClient _httpClient = GetIt.instance.get<GlasHttpClient>();

  Future<void> createKnownWord(String text) async {
    final response = await _httpClient.post(
        'known-words', CreateKnownWordDTO(text: text).toJson());

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to create known word: ${response.reasonPhrase}');
    }
  }

  Future<List<KnownWordDTO>> getKnownWords() async {
    final response = await _httpClient.get('known-words');

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
          'Failed to retrieve known words: ${response.reasonPhrase}');
    }

    var rawList = jsonDecode(response.body) as List;
    return rawList.map((i) => KnownWordDTO.fromJson(i)).toList();
  }
}
