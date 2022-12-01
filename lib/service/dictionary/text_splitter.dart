import 'package:glas_client/service/dictionary/text_part.dart';
import 'package:glas_client/service/dictionary/translatable_text_part.dart';

class TextSplitter {
  static final RegExp _textPartsRegex = RegExp(
      r"((?<![\wäöüÄÖÜß'-])(?=[\wäöüÄÖÜß'-])|(?<=[\wäöüÄÖÜß'-])(?![\wäöüÄÖÜß'-]))",
      unicode: true);
  static final RegExp _wordRegex = RegExp(r"[\wäöüÄÖÜß'-]+", unicode: true);

  static List<TextPart> split(String text) {
    return text
        .split(_textPartsRegex)
        .map((e) =>
            _wordRegex.hasMatch(e) ? TranslatableTextPart(e) : TextPart(e))
        .toList();
  }
}
