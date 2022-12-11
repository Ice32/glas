import 'package:meta/meta.dart';

@immutable
class CreateKnownWordDTO {
  final String text;

  const CreateKnownWordDTO({
    required this.text,
  });

  Map<String, String> toJson() {
    return <String, String>{'text': text};
  }
}
