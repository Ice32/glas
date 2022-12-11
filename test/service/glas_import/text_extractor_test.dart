import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:glas_client/api/glas_import/dto/known_word_dto.dart';
import 'package:glas_client/service/import/known_words_service.dart';
import 'package:glas_client/service/import/text_extractor.dart';
import 'package:glas_client/service/import/text_part.dart';
import 'package:glas_client/service/import/translatable_text_part.dart';
import 'package:glas_client/service/import/word.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'text_extractor_test.mocks.dart';

final getIt = GetIt.instance;

@GenerateNiceMocks([MockSpec<KnownWordsService>()])
void main() {
  late MockKnownWordsService knownWordsService;

  setUp(() {
    knownWordsService = MockKnownWordsService();
    getIt.registerSingleton<KnownWordsService>(knownWordsService);
  });

  tearDown(() {
    getIt.reset();
  });

  group('Text extractor', () {
    group('Extract', () {
      test('should return known words', () async {
        var knownWord = KnownWordDTO(id: 1, text: 'first');
        when(knownWordsService.getKnownWords())
            .thenAnswer((realInvocation) => Future.value([knownWord]));
        var expected = [
          Word('first', knownWord: knownWord),
          const TextPart(' '),
          const TranslatableTextPart('second'),
        ];

        var actual = await TextExtractor.extract('first second');

        expect(actual, expected);
        var translatableTextPart = actual[0] as Word;
        expect(translatableTextPart.knownWord, knownWord);
      });
    });
  });
}
