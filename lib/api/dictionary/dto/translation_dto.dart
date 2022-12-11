import 'package:meta/meta.dart';

@immutable
class TranslationDTO {
  final String translation;
  final String source;

  const TranslationDTO({
    required this.translation,
    required this.source,
  });

  factory TranslationDTO.fromJson(Map<String, dynamic> json) {
    return TranslationDTO(
      translation: json['translation'],
      source: json['source'],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'translation': translation, 'source': source};
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TranslationDTO &&
          runtimeType == other.runtimeType &&
          translation == other.translation;

  @override
  int get hashCode => translation.hashCode;
}
