import 'package:get_it/get_it.dart';
import 'package:glas_client/api/glas_import/dto/create_known_word_dto.dart';

import '../../api/glas_http_client.dart';

class KnownWordsService {
  final GlasHttpClient httpClient = GetIt.instance.get<GlasHttpClient>();

  Future<void> createKnownWord(String text) async {
    final response = await httpClient.post(
        'known-words', CreateKnownWordDTO(text: text).toJson());

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to create known word: ${response.reasonPhrase}');
    }
  }
}
