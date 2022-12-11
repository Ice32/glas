class KnownWordDTO {
  final int id;
  final String text;

  KnownWordDTO({
    required this.id,
    required this.text,
  });

  factory KnownWordDTO.fromJson(Map<String, dynamic> json) {
    return KnownWordDTO(
      id: json['id'],
      text: json['text'],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'id': id, 'text': text};
  }

  @override
  bool operator ==(Object other) {
    return other is KnownWordDTO && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}
