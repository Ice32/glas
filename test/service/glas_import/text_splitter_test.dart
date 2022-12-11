import 'package:flutter_test/flutter_test.dart';
import 'package:glas_client/service/import/text_part.dart';
import 'package:glas_client/service/import/text_splitter.dart';
import 'package:glas_client/service/import/translatable_text_part.dart';

void main() {
  group('Text splitter', () {
    group('Split', () {
      test('should split words on space', () {
        expect(TextSplitter.split('first second'), [
          const TranslatableTextPart('first'),
          const TextPart(' '),
          const TranslatableTextPart('second')
        ]);
      });
      test('should split words on newline', () {
        expect(TextSplitter.split('first\nsecond'), [
          const TranslatableTextPart('first'),
          const TextPart('\n'),
          const TranslatableTextPart('second')
        ]);
      });
      test('should split words on comma', () {
        expect(TextSplitter.split('first,second'), [
          const TranslatableTextPart('first'),
          const TextPart(','),
          const TranslatableTextPart('second')
        ]);
      });
      test('should split words on period', () {
        expect(TextSplitter.split('first.second'), [
          const TranslatableTextPart('first'),
          const TextPart('.'),
          const TranslatableTextPart('second')
        ]);
      });
      test('should not split on umlauts', () {
        expect(TextSplitter.split('können'),
            [const TranslatableTextPart('können')]);
      });
      test('should not split on \'', () {
        expect(
            TextSplitter.split('it\'s'), [const TranslatableTextPart('it\'s')]);
      });
      test('should not split on dash', () {
        expect(TextSplitter.split('Java-Entwicklung'),
            [const TranslatableTextPart('Java-Entwicklung')]);
      });
      test('should not split on numbers', () {
        expect(TextSplitter.split('year 2022.'), [
          const TranslatableTextPart('year'),
          const TextPart(' '),
          const TextPart('2022'),
          const TextPart('.')
        ]);
      });
    });
  });
}
