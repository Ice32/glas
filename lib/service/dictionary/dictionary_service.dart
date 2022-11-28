import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:glas_client/api/dictionary/dto/phrase_response_dto.dart';

import '../../api/glas_http_client.dart';

class DictionaryService {
  final GlasHttpClient httpClient = GetIt.instance.get<GlasHttpClient>();

  Future<PhraseResponseDTO> getTranslations(String phrase) async {
    final response = await httpClient.get('translations', {'phrase': phrase});

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
          'Failed to retrieve translations: ${response.reasonPhrase}');
    }

    return PhraseResponseDTO.fromJson(jsonDecode(response.body));
  }
}
