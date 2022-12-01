import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:logger/logger.dart';

import '../api/dictionary/dto/phrase_response_dto.dart';
import '../service/dictionary/dictionary_service.dart';

final getIt = GetIt.instance;

class Word extends StatefulWidget {
  late final String word;

  Word(String data, {Key? key}) : super(key: key) {
    word = data;
  }

  @override
  State<Word> createState() => _WordState();
}

class _WordState extends State<Word> {
  final dictionaryService = getIt.get<DictionaryService>();

  final tooltipController = JustTheController();

  final logger = Logger();
  final StreamController<PhraseResponseDTO> streamController =
      StreamController.broadcast();

  @override
  Widget build(BuildContext context) {
    return JustTheTooltip(
      onShow: () async => streamController
          .add(await dictionaryService.getTranslations(widget.word)),
      controller: tooltipController,
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
                return Text(resolvedPhraseResponse.translations[0].translation);
              }
              if (snapshot.hasError) {
                return Text("Error: ${snapshot.error!.toString()}");
              }
              return const Text("Loading...");
            },
          )),
      child: GestureDetector(
        child: Text(
          widget.word,
          style: Theme.of(context).textTheme.bodyLarge,
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
