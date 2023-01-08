import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:glas_client/api/glas_http_client.dart';
import 'package:glas_client/api/glas_import/dto/my_word_dto.dart';
import 'package:glas_client/service/import/my_words_service.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'my_words_service_test.mocks.dart';

final getIt = GetIt.instance;

void stubResponseStatus(MockGlasHttpClient client, int status) {
  when(client.post('imports', any))
      .thenAnswer((realInvocation) => Future.value(http.Response('', status)));
}

@GenerateNiceMocks([MockSpec<GlasHttpClient>()])
void main() {
  group('My words service', () {
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
        when(client.post('my-words', any)).thenAnswer(
            (realInvocation) => Future.value(http.Response('', 204)));
        const text = "aWord";

        await MyWordsService().createKnownWord(text);

        verify(client.post('my-words', {'text': text, 'isKnown': true}));
      });

      test('should throw exception if response status less than 200', () async {
        when(client.post('my-words', any)).thenAnswer(
            (realInvocation) => Future.value(http.Response('', 199)));

        expect(() async => MyWordsService().createKnownWord('aWord'),
            throwsException);
      });

      test('should throw exception if response status > 299', () async {
        when(client.post('my-words', any)).thenAnswer(
            (realInvocation) => Future.value(http.Response('', 300)));

        expect(() async => MyWordsService().createKnownWord('aWord'),
            throwsException);
      });
    });

    group('Get my words', () {
      test('should return my words', () async {
        List<MyWordDTO> myWords = [
          const MyWordDTO(id: 1, text: 'first word'),
          const MyWordDTO(id: 2, text: 'second word'),
        ];
        when(client.get('my-words')).thenAnswer((realInvocation) =>
            Future.value(http.Response(jsonEncode(myWords), 200)));

        var actual = await MyWordsService().geMyWords();

        expect(actual, equals(myWords));
      });

      test('should throw exception if response status less than 200', () async {
        when(client.get('my-words')).thenAnswer(
            (realInvocation) => Future.value(http.Response('', 199)));

        expect(() async => MyWordsService().geMyWords(), throwsException);
      });

      test('should throw exception if response status > 299', () async {
        when(client.get('my-words')).thenAnswer(
            (realInvocation) => Future.value(http.Response('', 300)));

        expect(() async => MyWordsService().geMyWords(), throwsException);
      });
    });
  });
}
