import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glas_client/api/dictionary/dto/phrase_response_dto.dart';
import 'package:glas_client/api/dictionary/dto/translation_dto.dart';
import 'package:glas_client/api/glas_http_client.dart';
import 'package:glas_client/api/glas_import/dto/import_dto.dart';
import 'package:glas_client/screens/import_page.dart';
import 'package:glas_client/service/dictionary/dictionary_service.dart';
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

      expect(find.text('text translation'), findsOneWidget);
    });
  });
}
