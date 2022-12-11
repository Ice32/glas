import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:glas_client/api/glas_http_client.dart';
import 'package:glas_client/api/glas_import/dto/known_word_dto.dart';
import 'package:glas_client/service/import/known_words_service.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'known_words_service_test.mocks.dart';

final getIt = GetIt.instance;

void stubResponseStatus(MockGlasHttpClient client, int status) {
  when(client.post('imports', any))
      .thenAnswer((realInvocation) => Future.value(http.Response('', status)));
}

@GenerateNiceMocks([MockSpec<GlasHttpClient>()])
void main() {
  group('Known words service', () {
    late MockGlasHttpClient client;

    setUp(() {
      var glasHttpClient = MockGlasHttpClient();
      getIt.registerSingleton<GlasHttpClient>(glasHttpClient);
      client = glasHttpClient;
    });

    tearDown(() {
      getIt.reset();
    });

    group('Create known word', () {
      test('should call http client', () async {
        when(client.post('known-words', any)).thenAnswer(
            (realInvocation) => Future.value(http.Response('', 204)));
        const text = "aWord";

        await KnownWordsService().createKnownWord(text);

        verify(client.post('known-words', {'text': text}));
      });

      test('should throw exception if response status less than 200', () async {
        when(client.post('known-words', any)).thenAnswer(
            (realInvocation) => Future.value(http.Response('', 199)));

        expect(() async => KnownWordsService().createKnownWord('aWord'),
            throwsException);
      });

      test('should throw exception if response status > 299', () async {
        when(client.post('known-words', any)).thenAnswer(
            (realInvocation) => Future.value(http.Response('', 300)));

        expect(() async => KnownWordsService().createKnownWord('aWord'),
            throwsException);
      });
    });

    group('Get known words', () {
      test('should return imports', () async {
        List<KnownWordDTO> knownWords = [
          KnownWordDTO(id: 1, text: 'first word'),
          KnownWordDTO(id: 2, text: 'second word'),
        ];
        when(client.get('known-words')).thenAnswer((realInvocation) =>
            Future.value(http.Response(jsonEncode(knownWords), 200)));

        var actual = await KnownWordsService().getKnownWords();

        expect(actual, equals(knownWords));
      });

      test('should throw exception if response status less than 200', () async {
        when(client.get('known-words')).thenAnswer(
            (realInvocation) => Future.value(http.Response('', 199)));

        expect(
            () async => KnownWordsService().getKnownWords(), throwsException);
      });

      test('should throw exception if response status > 299', () async {
        when(client.get('known-words')).thenAnswer(
            (realInvocation) => Future.value(http.Response('', 300)));

        expect(
            () async => KnownWordsService().getKnownWords(), throwsException);
      });
    });
  });
}
