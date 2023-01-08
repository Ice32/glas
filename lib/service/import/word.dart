import 'package:glas_client/api/glas_import/dto/my_word_dto.dart';
import 'package:glas_client/service/import/translatable_text_part.dart';
import 'package:meta/meta.dart';

@immutable
class Word extends TranslatableTextPart {
  const Word(String value, {this.myWord}) : super(value);
  final MyWordDTO? myWord;

  @override
  bool operator ==(Object other) {
    return other is Word && value == other.value;
  }

  @override
  int get hashCode => value.hashCode;
}
