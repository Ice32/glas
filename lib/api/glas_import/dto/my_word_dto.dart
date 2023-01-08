import 'package:meta/meta.dart';

@immutable
class MyWordDTO {
  final int id;
  final String text;

  const MyWordDTO({
    required this.id,
    required this.text,
  });

  factory MyWordDTO.fromJson(Map<String, dynamic> json) {
    return MyWordDTO(
      id: json['id'],
      text: json['text'],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'id': id, 'text': text};
  }

  @override
  bool operator ==(Object other) {
    return other is MyWordDTO && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}
