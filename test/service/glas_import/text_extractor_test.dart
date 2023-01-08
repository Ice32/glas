import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:glas_client/api/glas_import/dto/my_word_dto.dart';
import 'package:glas_client/service/import/my_words_service.dart';
import 'package:glas_client/service/import/text_extractor.dart';
import 'package:glas_client/service/import/text_part.dart';
import 'package:glas_client/service/import/translatable_text_part.dart';
import 'package:glas_client/service/import/word.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'text_extractor_test.mocks.dart';

final getIt = GetIt.instance;

@GenerateNiceMocks([MockSpec<MyWordsService>()])
void main() {
  late MockMyWordsService myWordsService;

  setUp(() {
    myWordsService = MockMyWordsService();
    getIt.registerSingleton<MyWordsService>(myWordsService);
  });

  tearDown(() {
    getIt.reset();
  });

  group('Text extractor', () {
    group('Extract', () {
      test('should return my words', () async {
        var myWord = const MyWordDTO(id: 1, text: 'first');
        when(myWordsService.geMyWords())
            .thenAnswer((realInvocation) => Future.value([myWord]));
        var expected = [
          Word('first', myWord: myWord),
          const TextPart(' '),
          const TranslatableTextPart('second'),
        ];

        var actual = await TextExtractor.extract('first second');

        expect(actual, expected);
        var translatableTextPart = actual[0] as Word;
        expect(translatableTextPart.myWord, myWord);
      });
    });
  });
}
