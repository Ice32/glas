import 'package:glas_client/service/import/text_part.dart';

class TranslatableTextPart extends TextPart {
  TranslatableTextPart(String value) : super(value);

  @override
  bool operator ==(Object other) {
    return other is TranslatableTextPart && value == other.value;
  }

  @override
  int get hashCode => value.hashCode;
}
