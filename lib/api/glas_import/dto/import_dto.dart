class ImportDTO {
  final String text;
  final String title;
  final int id;

  ImportDTO({
    required this.title,
    required this.text,
    required this.id,
  });

  factory ImportDTO.fromJson(Map<String, dynamic> json) {
    return ImportDTO(
      id: json['id'],
      title: json['title'],
      text: json['text'],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'id': id, 'title': title, 'text': text};
  }

  @override
  bool operator ==(Object other) {
    return other is ImportDTO && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}
