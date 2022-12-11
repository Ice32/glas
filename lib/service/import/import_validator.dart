import 'package:meta/meta.dart';

@immutable
class ImportValidator {
  static String? validateImportText(String? value) {
    return value == null || value.isEmpty ? "Import text can't be empty" : null;
  }

  static String? validateImportTitle(String? value) {
    return value == null || value.isEmpty
        ? "Import title can't be empty"
        : null;
  }
}
