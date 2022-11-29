import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glas_client/api/glas_import/dto/import_dto.dart';
import 'package:glas_client/screens/import_page.dart';

MaterialApp importPage(
    GlobalKey<ScaffoldState> importPageScaffoldKey, ImportDTO importDTO) {
  return MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: ImportPage(
      importDTO,
      key: importPageScaffoldKey,
    ),
  );
}

void main() {
  final importPageScaffoldKey = GlobalKey<ScaffoldState>();

  group('Import page widget test', () {
    testWidgets('should render title', (WidgetTester tester) async {
      final importDTO =
          ImportDTO(title: 'Import 1 title', text: 'Import 1 text', id: 1);

      await tester.pumpWidget(importPage(importPageScaffoldKey, importDTO));

      expect(find.text('Import 1 title'), findsOneWidget);
    });

    testWidgets('should display each import text word as a separate span',
        (WidgetTester tester) async {
      final importDTO =
          ImportDTO(title: 'Import 1 title', text: 'Import 1 text', id: 1);

      await tester.pumpWidget(importPage(importPageScaffoldKey, importDTO));

      expect(find.text('Import', findRichText: true), findsOneWidget);
      expect(find.text('1', findRichText: true), findsOneWidget);
      expect(find.text('text', findRichText: true), findsOneWidget);
    });
  });
}
