import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
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
  final _formKey = GlobalKey<FormState>();
  final importAPI = GetIt.instance.get<ImportService>();

  void submitPressed() async {
    if (_formKey.currentState!.validate()) {
      var scaffoldMessenger = ScaffoldMessenger.of(context);
      try {
        await importAPI.createImport(importTextController.text);
        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Processing your import')),
        );
        importTextController.clear();
      } catch (ex) {
        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Unknown error occurred')),
        );
      }
    }
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
