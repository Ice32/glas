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
    testWidgets('should render title and text', (WidgetTester tester) async {
      final importDTO =
          ImportDTO(title: 'Import 1 title', text: 'Import 1 text', id: 1);

      await tester.pumpWidget(importPage(importPageScaffoldKey, importDTO));
      await tester.pump();

      expect(find.text('Import 1 title'), findsOneWidget);
      expect(
          find.byWidgetPredicate((widget) =>
              widget is RichText &&
              widget.text.toPlainText() == 'Import 1 text'),
          findsOneWidget);
    });
  });
}
