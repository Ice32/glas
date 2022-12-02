import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../api/dictionary/dto/phrase_response_dto.dart';

final getIt = GetIt.instance;

class WordTooltipContent extends StatefulWidget {
  late final PhraseResponseDTO phraseResponseDTO;

  WordTooltipContent(PhraseResponseDTO data, {Key? key}) : super(key: key) {
    phraseResponseDTO = data;
  }

  @override
  State<WordTooltipContent> createState() => _WordTooltipContentState();
}

class _WordTooltipContentState extends State<WordTooltipContent> {
  static const numTranslationsToShow = 5;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ...widget.phraseResponseDTO.translations
            .toSet()
            .toList()
            .sublist(
                0,
                min(numTranslationsToShow,
                    widget.phraseResponseDTO.translations.length))
            .mapIndexed((i, t) => Text("${i + 1}: ${t.translation}")),
        Row(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 5),
              child: ElevatedButton(
                  key: const Key('addToMyWordsButton'),
                  onPressed: () {},
                  child: const Text("Add to my words")),
            ),
            OutlinedButton.icon(
                icon: const Icon(
                  Icons.lightbulb,
                  color: Color(0xffffd517),
                ),
                key: const Key('iKnowThisWordButton'),
                onPressed: () {},
                label: const Text("I know this word")),
          ],
        )
      ],
    );
  }
}
