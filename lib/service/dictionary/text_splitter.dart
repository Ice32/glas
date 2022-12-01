import 'package:glas_client/service/dictionary/text_part.dart';

class TextSplitter {
  static final RegExp _regex = RegExp(
      r"((?<![\wäöüÄÖÜß'-])(?=[\wäöüÄÖÜß'-])|(?<=[\wäöüÄÖÜß'-])(?![\wäöüÄÖÜß'-]))",
      unicode: true);

  static List<TextPart> split(String text) {
    return text.split(_regex).map((e) => TextPart(e)).toList();
  }
}
