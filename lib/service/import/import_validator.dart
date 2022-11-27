class ImportValidator {
  static String? validateImportText(String? value) {
    return value == null || value.isEmpty ? "Import text can't be empty" : null;
  }
}
