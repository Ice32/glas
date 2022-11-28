import 'package:flutter_test/flutter_test.dart';
import 'package:glas_client/service/import/import_validator.dart';

void main() {
  group('Validators', () {
    group('Validate import text', () {
      test('should return error string if import text empty', () {
        final result = ImportValidator.validateImportText('');
        expect(result, 'Import text can\'t be empty');
      });
      test('should return null if import text not empty', () {
        final result = ImportValidator.validateImportText('import text');
        expect(result, null);
      });
    });
    group('Validate import title', () {
      test('should return error string if import title empty', () {
        final result = ImportValidator.validateImportTitle('');
        expect(result, 'Import title can\'t be empty');
      });
      test('should return null if import title not empty', () {
        final result = ImportValidator.validateImportTitle('import title');
        expect(result, null);
      });
    });
  });
}
