import 'package:flutter/material.dart';
import 'package:glas_client/shared/drawer_menu.dart';

class ImportPage extends StatefulWidget {
  const ImportPage({Key? key}) : super(key: key);

  @override
  State<ImportPage> createState() => _ImportPageState();
}

class _ImportPageState extends State<ImportPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Import"),
        ),
        drawer: const DrawerMenu(),
        body: const Center(
          child: TextField(),
        ));
  }
}
