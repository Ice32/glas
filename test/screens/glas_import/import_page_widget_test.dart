import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:glas_client/api/dictionary/dto/phrase_response_dto.dart';
import 'package:glas_client/api/dictionary/dto/translation_dto.dart';
import 'package:glas_client/api/glas_http_client.dart';
import 'package:glas_client/api/glas_import/dto/import_dto.dart';
import 'package:glas_client/api/glas_import/dto/my_word_dto.dart';
import 'package:glas_client/screens/import_page.dart';
import 'package:glas_client/service/dictionary/dictionary_service.dart';
import 'package:glas_client/service/import/my_words_service.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'import_page_widget_test.mocks.dart';

void stubTranslationsResponse(MockGlasHttpClient httpClient, String phrase,
    List<TranslationDTO> translations) {
  when(httpClient.get('translations', {'phrase': phrase})).thenAnswer(
      (realInvocation) => Future.value(http.Response(
          jsonEncode(
              PhraseResponseDTO(phrase: phrase, translations: translations)),
          200)));
}

void stubMyWordsResponse(
    MockGlasHttpClient httpClient, List<MyWordDTO> myWords) {
  when((GetIt.instance.get<GlasHttpClient>() as MockGlasHttpClient)
          .get('my-words', any))
      .thenAnswer((realInvocation) =>
          Future.value(http.Response(jsonEncode(myWords), 200)));
}

MaterialApp importPage(
    GlobalKey<ScaffoldState> importPageScaffoldKey, ImportDTO importDTO) {
  return MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: ImportPage(
      importDTO,
      key: importPageScaffoldKey,
    ),
  );
}

@GenerateNiceMocks([MockSpec<GlasHttpClient>()])
void main() {
  group('Import page widget test', () {
    final getIt = GetIt.instance;
    final importPageScaffoldKey = GlobalKey<ScaffoldState>();

    final httpClient = MockGlasHttpClient();

    setUp(() async {
      getIt.registerSingleton<GlasHttpClient>(httpClient);
      getIt.registerSingleton<DictionaryService>(DictionaryService());
      getIt.registerSingleton<MyWordsService>(MyWordsService());
    });

    tearDown(() async {
      await getIt.reset();
      reset(httpClient);
    });

    testWidgets('should render title', (WidgetTester tester) async {
      stubMyWordsResponse(httpClient, []);
      const importDTO =
          ImportDTO(title: 'Import 1 title', text: 'Import 1 text', id: 1);

      await tester.pumpWidget(importPage(importPageScaffoldKey, importDTO));
      await tester.pumpAndSettle();

      expect(find.text('Import 1 title'), findsOneWidget);
    });

    testWidgets('should display each import text word as a separate span',
        (WidgetTester tester) async {
      stubMyWordsResponse(httpClient, []);
      const importDTO =
          ImportDTO(title: 'Import 1 title', text: 'Import 1 text', id: 1);

      await tester.pumpWidget(importPage(importPageScaffoldKey, importDTO));
      await tester.pumpAndSettle();

      expect(find.text('Import', findRichText: true), findsOneWidget);
      expect(find.text('1', findRichText: true), findsOneWidget);
      expect(find.text('text', findRichText: true), findsOneWidget);
    });

    testWidgets('tapping on a word shows translation',
        (WidgetTester tester) async {
      stubMyWordsResponse(httpClient, []);
      stubTranslationsResponse(httpClient, 'text', [
        const TranslationDTO(translation: 'text translation', source: 'text')
      ]);
      const importDTO =
          ImportDTO(title: 'Import 1 title', text: 'Import 1 text', id: 1);

      await tester.pumpWidget(importPage(importPageScaffoldKey, importDTO));
      await tester.pumpAndSettle();

      await tester.tap(find.text('text'));
      await tester.pumpAndSettle();

      expect(find.textContaining('text translation'), findsOneWidget);
      expect(find.text('I know this word'), findsOneWidget);
    });

    testWidgets('should show 5 translations', (WidgetTester tester) async {
      stubMyWordsResponse(httpClient, []);
      stubTranslationsResponse(httpClient, 'text', [
        const TranslationDTO(translation: 'text translation 1', source: 'text'),
        const TranslationDTO(translation: 'text translation 2', source: 'text'),
        const TranslationDTO(translation: 'text translation 3', source: 'text'),
        const TranslationDTO(translation: 'text translation 4', source: 'text'),
        const TranslationDTO(translation: 'text translation 5', source: 'text'),
        const TranslationDTO(translation: 'text translation 6', source: 'text'),
      ]);
      const importDTO =
          ImportDTO(title: 'Import 1 title', text: 'Import 1 text', id: 1);

      await tester.pumpWidget(importPage(importPageScaffoldKey, importDTO));
      await tester.pumpAndSettle();

      await tester.tap(find.text('text'));
      await tester.pumpAndSettle();

      expect(find.text('1: text translation 1'), findsOneWidget);
      expect(find.text('2: text translation 2'), findsOneWidget);
      expect(find.text('3: text translation 3'), findsOneWidget);
      expect(find.text('4: text translation 4'), findsOneWidget);
      expect(find.text('5: text translation 5'), findsOneWidget);
      expect(find.text('6: text translation 6'), findsNothing);
    });

    testWidgets('should hide translations with duplicate text',
        (WidgetTester tester) async {
      stubMyWordsResponse(httpClient, []);
      stubTranslationsResponse(httpClient, 'text', [
        const TranslationDTO(translation: 'text translation 1', source: 'text'),
        const TranslationDTO(
            translation: 'text translation 2', source: 'text 1'),
        const TranslationDTO(
            translation: 'text translation 2', source: 'text 2'),
        const TranslationDTO(translation: 'text translation 3', source: 'text'),
        const TranslationDTO(translation: 'text translation 4', source: 'text'),
        const TranslationDTO(translation: 'text translation 5', source: 'text'),
        const TranslationDTO(translation: 'text translation 6', source: 'text'),
      ]);
      const importDTO =
          ImportDTO(title: 'Import 1 title', text: 'Import 1 text', id: 1);

      await tester.pumpWidget(importPage(importPageScaffoldKey, importDTO));
      await tester.pumpAndSettle();

      await tester.tap(find.text('text'));
      await tester.pumpAndSettle();

      expect(find.textContaining('text translation 1'), findsOneWidget);
      expect(find.textContaining('text translation 2'), findsOneWidget);
      expect(find.textContaining('text translation 3'), findsOneWidget);
      expect(find.textContaining('text translation 4'), findsOneWidget);
      expect(find.textContaining('text translation 5'), findsOneWidget);
      expect(find.textContaining('text translation 6'), findsNothing);
    });

    testWidgets("tapping on 'I know this word' calls API",
        (WidgetTester tester) async {
      const word = 'aWord';
      stubMyWordsResponse(httpClient, []);
      when(httpClient.post('my-words', any))
          .thenAnswer((realInvocation) => Future.value(http.Response('', 204)));
      stubTranslationsResponse(httpClient, word, [
        const TranslationDTO(translation: 'text translation', source: word)
      ]);
      const importDTO =
          ImportDTO(title: 'Import 1 title', text: 'Import 1 $word', id: 1);
      await tester.pumpWidget(importPage(importPageScaffoldKey, importDTO));
      await tester.pumpAndSettle();
      await tester.tap(find.text(word));
      await tester.pumpAndSettle();

      await tester.tap(find.text('I know this word'));

      verify(httpClient.post('my-words', {'text': word, 'isKnown': true}));
      await tester.pumpAndSettle();
      expect(find.text('I know this word'), findsNothing);
    });

    testWidgets('should display untranslatable text parts without background',
        (WidgetTester tester) async {
      stubMyWordsResponse(httpClient, []);
      const importDTO =
          ImportDTO(title: 'Import 1 title', text: 'Import 1 text.', id: 1);

      await tester.pumpWidget(importPage(importPageScaffoldKey, importDTO));
      await tester.pumpAndSettle();

      expect(
          (tester.firstWidget(find.text('.', findRichText: true)) as RichText)
              .text
              .style
              ?.backgroundColor,
          null);
    });

    testWidgets('should display known words without a background color',
        (WidgetTester tester) async {
          stubMyWordsResponse(httpClient, [const MyWordDTO(id: 1, text: 'text')]);
      const importDTO =
          ImportDTO(title: 'Import 1 title', text: 'Import 1 text', id: 1);

      await tester.pumpWidget(importPage(importPageScaffoldKey, importDTO));
      await tester.pumpAndSettle();

      expect(
          (tester.firstWidget(find.text('text', findRichText: true))
                  as RichText)
              .text
              .style
              ?.backgroundColor,
          null);
    });
  });
}
