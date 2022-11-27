import 'package:glas_client/api/dictionary/dto/translation_dto.dart';

class PhraseResponseDTO {
  final String phrase;
  final List<TranslationDTO> translations;

  PhraseResponseDTO({
    required this.phrase,
    required this.translations,
  });

  factory PhraseResponseDTO.fromJson(Map<String, dynamic> jsonValue) {
    var list = jsonValue['translations'] as List;
    List<TranslationDTO> translationDTOs =
        list.map((i) => TranslationDTO.fromJson(i)).toList();

    return PhraseResponseDTO(
      phrase: jsonValue['phrase'],
      translations: translationDTOs,
    );
  }
}
