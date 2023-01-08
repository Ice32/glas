import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:glas_client/api/glas_import/dto/my_word_dto.dart';
import 'package:glas_client/service/import/my_words_service.dart';
import 'package:glas_client/shared/drawer_menu.dart';
import 'package:logger/logger.dart';

import 'create_import_page.dart';

final getIt = GetIt.instance;

class MyWordsPage extends StatefulWidget {
  const MyWordsPage({Key? key}) : super(key: key);

  @override
  State<MyWordsPage> createState() => _MyWordsPageState();
}

class _MyWordsPageState extends State<MyWordsPage> {
  final _myWordsService = getIt.get<MyWordsService>();
  final _logger = Logger();

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
    return Scaffold(
        appBar: AppBar(
          title: const Text("My words"),
        ),
        drawer: const DrawerMenu(),
        body: FutureBuilder<List<MyWordDTO>>(
          future: _myWordsService.geMyWords(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) => Card(
                      child: ListTile(
                          title: Text(snapshot.data?[index].text ?? ''))));
            }
            if (snapshot.hasError) {
              _logger.w(snapshot.error);
              return ListView.builder(
                itemCount: 0,
                itemBuilder: (context, index) => const Card(),
              );
            }
            return ListView(children: const []);
          },
        ));
  }
}
