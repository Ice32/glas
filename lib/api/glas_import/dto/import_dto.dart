class ImportDTO {
  final String text;
  final int id;

  ImportDTO({
    required this.text,
    required this.id,
  });

  factory ImportDTO.fromJson(Map<String, dynamic> json) {
    return ImportDTO(
      id: json['id'],
      text: json['text'],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'id': id, 'text': text};
  }

  @override
  bool operator ==(Object other) {
    return other is ImportDTO && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}
