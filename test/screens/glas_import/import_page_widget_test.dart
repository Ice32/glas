import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glas_client/api/dictionary/dto/phrase_response_dto.dart';
import 'package:glas_client/api/dictionary/dto/translation_dto.dart';
import 'package:glas_client/api/glas_http_client.dart';
import 'package:glas_client/api/glas_import/dto/import_dto.dart';
import 'package:glas_client/screens/import_page.dart';
import 'package:glas_client/service/dictionary/dictionary_service.dart';
import 'package:glas_client/service/import/known_words_service.dart';
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
  final importPageScaffoldKey = GlobalKey<ScaffoldState>();

  late MockGlasHttpClient httpClient;

  setUp(() {
    var glasHttpClient = MockGlasHttpClient();
    getIt.registerSingleton<GlasHttpClient>(glasHttpClient);
    getIt.registerSingleton<DictionaryService>(DictionaryService());
    getIt.registerSingleton<KnownWordsService>(KnownWordsService());
    httpClient = glasHttpClient;
  });

  tearDown(() {
    getIt.reset();
  });

  group('Import page widget test', () {
    testWidgets('should render title', (WidgetTester tester) async {
      final importDTO =
          ImportDTO(title: 'Import 1 title', text: 'Import 1 text', id: 1);

      await tester.pumpWidget(importPage(importPageScaffoldKey, importDTO));

      expect(find.text('Import 1 title'), findsOneWidget);
    });

    testWidgets('should display each import text word as a separate span',
        (WidgetTester tester) async {
      final importDTO =
          ImportDTO(title: 'Import 1 title', text: 'Import 1 text', id: 1);

      await tester.pumpWidget(importPage(importPageScaffoldKey, importDTO));

      expect(find.text('Import', findRichText: true), findsOneWidget);
      expect(find.text('1', findRichText: true), findsOneWidget);
      expect(find.text('text', findRichText: true), findsOneWidget);
    });

    testWidgets('opening import page sends no http requests',
        (WidgetTester tester) async {
      final importDTO =
          ImportDTO(title: 'Import 1 title', text: 'Import 1 text', id: 1);

      await tester.pumpWidget(importPage(importPageScaffoldKey, importDTO));
      await tester.pumpAndSettle();

      verifyNoMoreInteractions(httpClient);
    });

    testWidgets('tapping on a word shows translation',
        (WidgetTester tester) async {
      stubTranslationsResponse(httpClient, 'text',
          [TranslationDTO(translation: 'text translation', source: 'text')]);
      final importDTO =
          ImportDTO(title: 'Import 1 title', text: 'Import 1 text', id: 1);

      await tester.pumpWidget(importPage(importPageScaffoldKey, importDTO));
      await tester.pumpAndSettle();

      await tester.tap(find.text('text'));
      await tester.pumpAndSettle();

      expect(find.textContaining('text translation'), findsOneWidget);
      expect(find.text('I know this word'), findsOneWidget);
    });

    testWidgets('should show 5 translations', (WidgetTester tester) async {
      stubTranslationsResponse(httpClient, 'text', [
        TranslationDTO(translation: 'text translation 1', source: 'text'),
        TranslationDTO(translation: 'text translation 2', source: 'text'),
        TranslationDTO(translation: 'text translation 3', source: 'text'),
        TranslationDTO(translation: 'text translation 4', source: 'text'),
        TranslationDTO(translation: 'text translation 5', source: 'text'),
        TranslationDTO(translation: 'text translation 6', source: 'text'),
      ]);
      final importDTO =
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
  });

  testWidgets('should hide translations with duplicate text',
      (WidgetTester tester) async {
    stubTranslationsResponse(httpClient, 'text', [
      TranslationDTO(translation: 'text translation 1', source: 'text'),
      TranslationDTO(translation: 'text translation 2', source: 'text 1'),
      TranslationDTO(translation: 'text translation 2', source: 'text 2'),
      TranslationDTO(translation: 'text translation 3', source: 'text'),
      TranslationDTO(translation: 'text translation 4', source: 'text'),
      TranslationDTO(translation: 'text translation 5', source: 'text'),
      TranslationDTO(translation: 'text translation 6', source: 'text'),
    ]);
    final importDTO =
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
    stubTranslationsResponse(httpClient, word,
        [TranslationDTO(translation: 'text translation', source: word)]);
    when(httpClient.post('known-words', any))
        .thenAnswer((realInvocation) => Future.value(http.Response('', 204)));
    final importDTO =
        ImportDTO(title: 'Import 1 title', text: 'Import 1 $word', id: 1);
    await tester.pumpWidget(importPage(importPageScaffoldKey, importDTO));
    await tester.pumpAndSettle();
    await tester.tap(find.text(word));
    await tester.pumpAndSettle();

    await tester.tap(find.text('I know this word'));

    verify(httpClient.post('known-words', {'text': word}));
  });
}
