import 'package:meta/meta.dart';

@immutable
class CreateMyWordDTO {
  final String text;
  final bool isKnown;

  const CreateMyWordDTO({
    required this.text,
    this.isKnown = false,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'text': text, 'isKnown': isKnown};
  }
}
