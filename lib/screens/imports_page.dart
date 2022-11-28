import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:glas_client/service/import/import_service.dart';
import 'package:glas_client/shared/drawer_menu.dart';
import 'package:logger/logger.dart';

import '../api/glas_import/dto/import_dto.dart';
import 'create_import_page.dart';

final getIt = GetIt.instance;

class ImportsPage extends StatefulWidget {
  const ImportsPage({Key? key}) : super(key: key);

  @override
  State<ImportsPage> createState() => _ImportsPageState();
}

class _ImportsPageState extends State<ImportsPage> {
  final importService = getIt.get<ImportService>();
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Imports"),
      ),
      drawer: const DrawerMenu(),
      body: FutureBuilder<List<ImportDTO>>(
        future: importService.getImports(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) => Card(
                    child: ListTile(
                        title: Text(snapshot.data?[index].title ?? ''))));
          }
          if (snapshot.hasError) {
            logger.w(snapshot.error);
            return ListView.builder(
              itemCount: 0,
              itemBuilder: (context, index) => const Card(),
            );
          }
          return ListView(children: const []);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigateToCreateImportPage,
        child: const Icon(Icons.add),
      ),
    );
  }
}
