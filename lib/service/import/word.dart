import 'package:glas_client/api/glas_import/dto/known_word_dto.dart';
import 'package:glas_client/service/import/translatable_text_part.dart';
import 'package:meta/meta.dart';

@immutable
class Word extends TranslatableTextPart {
  const Word(String value, {this.knownWord}) : super(value);
  final KnownWordDTO? knownWord;

  isKnown() {
    return knownWord != null;
  }

  @override
  bool operator ==(Object other) {
    return other is Word && value == other.value;
  }

  @override
  int get hashCode => value.hashCode;
}
