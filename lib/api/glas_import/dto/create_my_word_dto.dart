import 'package:meta/meta.dart';

@immutable
class CreateMyWordDTO {
  final String text;

  const CreateMyWordDTO({
    required this.text,
  });

  Map<String, String> toJson() {
    return <String, String>{'text': text};
  }
}
