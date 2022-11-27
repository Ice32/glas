import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:glas_client/api/glas_http_client.dart';
import 'package:glas_client/screens/create_import_page.dart';
import 'package:glas_client/screens/dictionary_page.dart';
import 'package:glas_client/service/import/import_service.dart';

final getIt = GetIt.instance;

void main() {
  getIt.registerSingleton<GlasHttpClient>(GlasHttpClient());
  getIt.registerSingleton<ImportService>(ImportService());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        "/dictionary": (context) => DictionaryPage(),
        "/import": (context) => CreateImportPage()
      },
      initialRoute: "/dictionary",
    );
  }
}
