import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:glas_client/api/phrase_response_dto.dart';
import 'package:glas_client/shared/drawer_menu.dart';
import 'package:http/http.dart' as http;

class DictionaryPage extends StatefulWidget {
  const DictionaryPage({Key? key}) : super(key: key);

  @override
  State<DictionaryPage> createState() => _DictionaryPageState();
}

class _DictionaryPageState extends State<DictionaryPage> {
  PhraseResponseDTO phraseResponse =
      PhraseResponseDTO(phrase: "", translations: []);

  @override
  void initState() {
    super.initState();
  }

  Future<PhraseResponseDTO> fetchTranslation(String phrase) async {
    final response = await http
        .get(Uri.parse('http://localhost:8080/translations?phrase=$phrase'));

    if (response.statusCode == 200) {
      return PhraseResponseDTO.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load album');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dictionary"),
      ),
      drawer: const DrawerMenu(),
      body: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        children: <Widget>[
          TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Phrase',
            ),
            onSubmitted: (String value) async {
              var fetched = await fetchTranslation(value);
              setState(() {
                phraseResponse = fetched;
              });
            },
          ),
          for (var item in phraseResponse.translations)
            Card(
              child: ListTile(
                leading: const FlutterLogo(),
                title: Text("${item.source}   ->   ${item.translation}"),
              ),
            ),
        ],
      ),
    );
  }
}
