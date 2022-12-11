import 'package:meta/meta.dart';

@immutable
class TextPart {
  final String value;

  const TextPart(this.value);

  @override
  bool operator ==(Object other) {
    return other is TextPart && value == other.value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() {
    return "TextPart($value)";
  }
}
