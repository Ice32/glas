class TranslationDTO {
  final String translation;
  final String source;

  TranslationDTO({
    required this.translation,
    required this.source,
  });

  factory TranslationDTO.fromJson(Map<String, dynamic> json) {
    return TranslationDTO(
      translation: json['translation'],
      source: json['source'],
    );
  }
}