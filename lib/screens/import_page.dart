import 'package:flutter/material.dart';
import 'package:glas_client/service/import/text_extractor.dart';
import 'package:glas_client/service/import/text_part.dart';
import 'package:glas_client/shared/drawer_menu.dart';
import 'package:glas_client/widgets/text_word.dart';
import 'package:logger/logger.dart';

import '../api/glas_import/dto/import_dto.dart';
import 'create_import_page.dart';

class ImportPage extends StatefulWidget {
  late final ImportDTO importDTO;

  ImportPage(ImportDTO data, {Key? key}) : super(key: key) {
    importDTO = data;
  }

  @override
  State<ImportPage> createState() => _ImportsPageState();
}

class _ImportsPageState extends State<ImportPage> {
  final logger = Logger();

  @override
  void initState() {
    super.initState();
  }

  void navigateToCreateImportPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateImportPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    var textStyle = Theme.of(context).textTheme.headlineLarge;

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Imports",
          ),
        ),
        drawer: const DrawerMenu(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                widget.importDTO.title,
                style: textStyle,
              ),
            ),
            Expanded(
                child: SingleChildScrollView(
                    child: Padding(
              padding: const EdgeInsets.all(10),
              child: FutureBuilder<List<TextPart>>(
                  future: TextExtractor.extract(
                      widget.importDTO.text.replaceAll("\n\n", "")),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return RichText(
                          text: TextSpan(
                              children: snapshot.data!
                                  .map((w) => WidgetSpan(child: TextWord(w)))
                                  .toList()));
                    }
                    if (snapshot.hasError) {
                      logger.e(snapshot.error!.toString());
                    }
                    return const Text('Loading...');
                  }),
            )))
          ],
        ));
  }
}
