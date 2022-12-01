import 'package:flutter_test/flutter_test.dart';
import 'package:glas_client/service/dictionary/text_part.dart';
import 'package:glas_client/service/dictionary/text_splitter.dart';

void main() {
  group('Text splitter', () {
    group('Split', () {
      testWidgets('should split words on space', (WidgetTester tester) async {
        expect(TextSplitter.split('first second'),
            [TextPart('first'), TextPart(' '), TextPart('second')]);
      });
      testWidgets('should split words on newline', (WidgetTester tester) async {
        expect(TextSplitter.split('first\nsecond'),
            [TextPart('first'), TextPart('\n'), TextPart('second')]);
      });
      testWidgets('should split words on comma', (WidgetTester tester) async {
        expect(TextSplitter.split('first,second'),
            [TextPart('first'), TextPart(','), TextPart('second')]);
      });
      testWidgets('should split words on period', (WidgetTester tester) async {
        expect(TextSplitter.split('first.second'),
            [TextPart('first'), TextPart('.'), TextPart('second')]);
      });
      testWidgets('should not split on umlauts', (WidgetTester tester) async {
        expect(TextSplitter.split('können'), [TextPart('können')]);
      });
      testWidgets('should not split on \'', (WidgetTester tester) async {
        expect(TextSplitter.split('it\'s'), [TextPart('it\'s')]);
      });
      testWidgets('should not split on dash', (WidgetTester tester) async {
        expect(TextSplitter.split('Java-Entwicklung'),
            [TextPart('Java-Entwicklung')]);
      });
      testWidgets('should not split on numbers', (WidgetTester tester) async {
        expect(TextSplitter.split('year 2022.'),
            [TextPart('year'), TextPart(' '), TextPart('2022'), TextPart('.')]);
      });
    });
  });
}
