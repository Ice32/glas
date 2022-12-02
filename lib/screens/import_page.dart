import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:glas_client/service/import/text_splitter.dart';
import 'package:glas_client/shared/drawer_menu.dart';
import 'package:glas_client/widgets/word.dart';
import 'package:logger/logger.dart';

import '../api/glas_import/dto/import_dto.dart';
import 'create_import_page.dart';

final getIt = GetIt.instance;

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
    List<WidgetSpan> words = TextSplitter.split(widget.importDTO.text)
        .map((word) => WidgetSpan(child: Word(word)))
        .toList();

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
                child: Padding(
              padding: const EdgeInsets.all(10),
              child: RichText(text: TextSpan(children: words)),
            ))
          ],
        ));
  }
}
