import 'package:meta/meta.dart';

@immutable
class CreateImportDTO {
  final String text;
  final String title;

  const CreateImportDTO({
    required this.title,
    required this.text,
  });

  Map<String, String> toJson() {
    return <String, String>{'title': title, 'text': text};
  }
}
