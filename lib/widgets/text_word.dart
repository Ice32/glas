import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:glas_client/service/import/text_part.dart';
import 'package:glas_client/service/import/word.dart';
import 'package:glas_client/widgets/word_tooltip_content.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:logger/logger.dart';

import '../api/dictionary/dto/phrase_response_dto.dart';
import '../service/dictionary/dictionary_service.dart';
import '../service/import/translatable_text_part.dart';

final getIt = GetIt.instance;

class TextWord extends StatefulWidget {
  late final TextPart word;

  TextWord(TextPart data, {Key? key}) : super(key: key) {
    word = data;
  }

  @override
  State<TextWord> createState() => _TextWordState();
}

class _TextWordState extends State<TextWord> {
  final dictionaryService = getIt.get<DictionaryService>();

  final tooltipController = JustTheController();

  final logger = Logger();
  final StreamController<PhraseResponseDTO> streamController =
      StreamController.broadcast();

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return JustTheTooltip(
      onShow: () async => streamController
          .add(await dictionaryService.getTranslations(widget.word.value)),
      controller: tooltipController,
      isModal: true,
      content: Padding(
          padding: const EdgeInsets.all(10),
          child: StreamBuilder<PhraseResponseDTO>(
            stream: streamController.stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var resolvedPhraseResponse = snapshot.data;
                if (resolvedPhraseResponse == null) {
                  throw NullThrownError();
                }
                if (resolvedPhraseResponse.translations.isEmpty) {
                  return const Text('No translation found');
                }
                return WordTooltipContent(resolvedPhraseResponse);
              }
              if (snapshot.hasError) {
                return Text("Error: ${snapshot.error!.toString()}");
              }
              return const Text("Loading...");
            },
          )),
      child: GestureDetector(
        child: Text(
          widget.word.value,
          style: themeData.textTheme.bodyLarge?.merge(TextStyle(
              backgroundColor:
                  widget.word is TranslatableTextPart && widget.word is! Word
                      ? const Color(0xff9fcfff)
                      : themeData.textTheme.bodyLarge?.backgroundColor)),
        ),
        onTap: () {
          tooltipController.showTooltip();
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    streamController.close();
  }
}
