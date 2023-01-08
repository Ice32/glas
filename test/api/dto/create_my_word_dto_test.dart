import 'package:flutter_test/flutter_test.dart';
import 'package:glas_client/api/glas_import/dto/create_my_word_dto.dart';

void main() {
  group('CreateMyWordDTO', () {
    test('should produce json with isKnown=false by default', () {
      const text = "aText";

      var createMyWordDTO = const CreateMyWordDTO(text: text);

      expect(createMyWordDTO.toJson(), {'text': text, 'isKnown': false});
    });

    test('should produce json with isKnown=false if not known', () {
      const text = "aText";

      var createMyWordDTO = const CreateMyWordDTO(text: text, isKnown: false);

      expect(createMyWordDTO.toJson(), {'text': text, 'isKnown': false});
    });

    test('should produce json with isKnown=true if known', () {
      const text = "aText";

      var createMyWordDTO = const CreateMyWordDTO(text: text, isKnown: true);

      expect(createMyWordDTO.toJson(), {'text': text, 'isKnown': true});
    });
  });
}
