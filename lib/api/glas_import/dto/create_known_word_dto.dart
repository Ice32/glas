class CreateKnownWordDTO {
  final String text;

  CreateKnownWordDTO({
    required this.text,
  });

  Map<String, String> toJson() {
    return <String, String>{'text': text};
  }
}
