import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:glas_client/api/dictionary/dto/phrase_response_dto.dart';
import 'package:glas_client/service/dictionary/dictionary_service.dart';
import 'package:glas_client/shared/drawer_menu.dart';

final getIt = GetIt.instance;

class DictionaryPage extends StatefulWidget {
  const DictionaryPage({Key? key}) : super(key: key);

  @override
  State<DictionaryPage> createState() => _DictionaryPageState();
}

class _DictionaryPageState extends State<DictionaryPage> {
  final dictionaryService = getIt.get<DictionaryService>();

  PhraseResponseDTO phraseResponse =
      const PhraseResponseDTO(phrase: "", translations: []);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dictionary"),
      ),
      drawer: const DrawerMenu(),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 10, 5, 5),
            child: TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Phrase',
              ),
              onSubmitted: (String value) async {
                var fetched = await dictionaryService.getTranslations(value);
                setState(() {
                  phraseResponse = fetched;
                });
              },
            ),
          ),
          Expanded(
              child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            children: [
              for (var item in phraseResponse.translations)
                Card(
                  child: ListTile(
                    leading: Padding(
                      padding: const EdgeInsets.all(9),
                      child: Image.asset(
                        'packages/country_icons/icons/flags/png/de.png',
                      ),
                    ),
                    title: Text("${item.source}   ->   ${item.translation}"),
                  ),
                ),
            ],
          ))
        ],
      ),
    );
  }
}
