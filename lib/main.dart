import 'package:flutter/material.dart';
import 'package:glas_client/screens/dictionary_page.dart';
import 'package:glas_client/screens/import_page.dart';

void main() {
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
        "/import": (context) => ImportPage()
      },
      initialRoute: "/dictionary",
    );
  }
}
