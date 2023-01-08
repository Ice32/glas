import 'package:collection/collection.dart';
import 'package:get_it/get_it.dart';
import 'package:glas_client/api/glas_import/dto/my_word_dto.dart';
import 'package:glas_client/service/import/my_words_service.dart';
import 'package:glas_client/service/import/text_part.dart';
import 'package:glas_client/service/import/text_splitter.dart';
import 'package:glas_client/service/import/word.dart';
import 'package:meta/meta.dart';

final getIt = GetIt.instance;

@immutable
class TextExtractor {
  static final myWordsService = getIt.get<MyWordsService>();

  static Future<List<TextPart>> extract(String text) async {
    var myWords = await myWordsService.geMyWords();
    return TextSplitter.split(text).map((e) {
      final MyWordDTO? myWord =
          myWords.firstWhereOrNull((kw) => kw.text == e.value);
      if (myWord != null) {
        return Word(e.value, myWord: myWord);
      }
      return e;
    }).toList();
  }
}
