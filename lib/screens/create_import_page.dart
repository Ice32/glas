import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:glas_client/screens/imports_page.dart';
import 'package:glas_client/service/import/import_service.dart';
import 'package:glas_client/service/import/import_validator.dart';
import 'package:glas_client/shared/drawer_menu.dart';

class CreateImportPage extends StatefulWidget {
  const CreateImportPage({Key? key}) : super(key: key);

  @override
  State<CreateImportPage> createState() => _CreateImportPageState();
}

class _CreateImportPageState extends State<CreateImportPage> {
  @override
  void initState() {
    super.initState();
  }

  final importTextController = TextEditingController();
  final importTitleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final importService = GetIt.instance.get<ImportService>();

  void submitPressed() async {
    if (_formKey.currentState!.validate()) {
      var scaffoldMessenger = ScaffoldMessenger.of(context);
      try {
        await importService.createImport(
            importTitleController.text, importTextController.text);
        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Processing your import')),
        );
        navigateToImportsPage();
      } catch (ex) {
        print(ex.toString());
        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Unknown error occurred')),
        );
      }
    }
  }

  void navigateToImportsPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ImportsPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Import"),
        ),
        drawer: const DrawerMenu(),
        body: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  key: const Key('importTitleField'),
                  controller: importTitleController,
                  validator: ImportValidator.validateImportTitle,
                ),
                TextFormField(
                  key: const Key('importTextField'),
                  controller: importTextController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  minLines: 10,
                  validator: ImportValidator.validateImportText,
                ),
                ElevatedButton(
                    key: const Key('submitButton'),
                    onPressed: submitPressed,
                    child: const Text("Import"))
              ],
            )));
  }

  @override
  void dispose() {
    importTextController.dispose();
    super.dispose();
  }
}
