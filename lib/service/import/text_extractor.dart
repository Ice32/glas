import 'package:collection/collection.dart';
import 'package:get_it/get_it.dart';
import 'package:glas_client/api/glas_import/dto/known_word_dto.dart';
import 'package:glas_client/service/import/known_words_service.dart';
import 'package:glas_client/service/import/text_part.dart';
import 'package:glas_client/service/import/text_splitter.dart';
import 'package:glas_client/service/import/word.dart';
import 'package:meta/meta.dart';

final getIt = GetIt.instance;

@immutable
class TextExtractor {
  static final knownWordsService = getIt.get<KnownWordsService>();

  static Future<List<TextPart>> extract(String text) async {
    var knownWords = await knownWordsService.getKnownWords();
    return TextSplitter.split(text).map((e) {
      final KnownWordDTO? knownWord =
          knownWords.firstWhereOrNull((kw) => kw.text == e.value);
      if (knownWord != null) {
        return Word(e.value, knownWord: knownWord);
      }
      return e;
    }).toList();
  }
}
