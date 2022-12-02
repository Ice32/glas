import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:glas_client/api/dictionary/dto/phrase_response_dto.dart';
import 'package:glas_client/api/dictionary/dto/translation_dto.dart';
import 'package:glas_client/api/glas_http_client.dart';
import 'package:glas_client/service/dictionary/dictionary_service.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'dictionary_service_test.mocks.dart';

final getIt = GetIt.instance;

@GenerateNiceMocks([MockSpec<GlasHttpClient>()])
void main() {
  group('Dictionary service', () {
    late MockGlasHttpClient client;

    setUp(() {
      var glasHttpClient = MockGlasHttpClient();
      getIt.registerSingleton<GlasHttpClient>(glasHttpClient);
      client = glasHttpClient;
    });

    tearDown(() {
      getIt.reset();
    });

    group('Get translations', () {
      test('should return imports', () async {
        PhraseResponseDTO phraseResponseDTO =
            PhraseResponseDTO(phrase: 'phrase', translations: [
          TranslationDTO(translation: 'translation 1', source: 'source 1'),
          TranslationDTO(translation: 'translation 2', source: 'source 2'),
        ]);
        when(client.get('translations', {'phrase': 'phrase'})).thenAnswer(
            (realInvocation) => Future.value(
                http.Response(jsonEncode(phraseResponseDTO), 204)));

        var actual = await DictionaryService().getTranslations('phrase');

        expect(actual, equals(phraseResponseDTO));
      });

      test('should throw exception if response status less than 200', () async {
        when(client.get('translations', any)).thenAnswer(
            (realInvocation) => Future.value(http.Response('', 199)));

        expect(() async => DictionaryService().getTranslations('a'),
            throwsException);
      });

      test('should throw exception if response status > 299', () async {
        when(client.get('translations', any)).thenAnswer(
            (realInvocation) => Future.value(http.Response('', 300)));

        expect(() async => DictionaryService().getTranslations('phrase'),
            throwsException);
      });
    });
  });
}
