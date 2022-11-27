class CreateImportDTO {
  final String text;

  CreateImportDTO({
    required this.text,
  });

  Map<String, String> toJson() {
    return <String, String>{'text': text};
  }
}
