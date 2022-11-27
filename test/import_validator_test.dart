import 'package:flutter_test/flutter_test.dart';
import 'package:glas_client/service/import/import_validator.dart';

void main() {
  group('Validators', () {
    test('should return error string if import text empty', () {
      final result = ImportValidator.validateImportText('');
      expect(result, 'Import text can\'t be empty');
    });
  });
}
