import 'dart:convert';

import 'package:glas_client/translation_dto.dart';

class PhraseResponseDTO {
  final String phrase;
  final List<TranslationDTO> translations;

  PhraseResponseDTO({
    required this.phrase,
    required this.translations,
  });

  factory PhraseResponseDTO.fromJson(Map<String, dynamic> jsonValue) {
    // Iterable l = jsonDecode(jsonValue['translations']);
    // List<TranslationDTO> translationDtos = (json.decode(jsonValue["translations"]) as List).map((i) => TranslationDTO.fromJson(i)).toList();

    var list = jsonValue['translations'] as List;
    print(list.runtimeType);
    List<TranslationDTO> translationDtos = list.map((i) => TranslationDTO.fromJson(i)).toList();

    return PhraseResponseDTO(
      phrase: jsonValue['phrase'],
      // translations: List<TranslationDTO>.from(l.map((model)=> TranslationDTO.fromJson(model))),
      translations:  translationDtos,
    );
  }
}
