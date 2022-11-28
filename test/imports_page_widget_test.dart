import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:glas_client/api/glas_http_client.dart';
import 'package:glas_client/api/glas_import/dto/import_dto.dart';
import 'package:glas_client/screens/create_import_page.dart';
import 'package:glas_client/screens/imports_page.dart';
import 'package:glas_client/service/import/import_service.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'import_service_test.mocks.dart';

final getIt = GetIt.instance;

MaterialApp importsPage(GlobalKey<ScaffoldState> importsPageScaffoldKey) {
  return MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: ImportsPage(
      key: importsPageScaffoldKey,
    ),
  );
}

void stubImportsResponse(
    MockGlasHttpClient httpClient, List<ImportDTO> imports) {
  when(httpClient.get('imports')).thenAnswer((realInvocation) =>
      Future.value(http.Response(jsonEncode(imports), 200)));
}

@GenerateNiceMocks([MockSpec<GlasHttpClient>()])
void main() {
  final importsPageScaffoldKey = GlobalKey<ScaffoldState>();
  late MockGlasHttpClient httpClient;

  setUp(() {
    var glasHttpClient = MockGlasHttpClient();
    getIt.registerSingleton<GlasHttpClient>(glasHttpClient);
    getIt.registerSingleton<ImportService>(ImportService());
    httpClient = glasHttpClient;
  });

  tearDown(() {
    getIt.reset();
  });

  group('Imports page widget test', () {
    testWidgets('should render imports', (WidgetTester tester) async {
      stubImportsResponse(httpClient, [
        ImportDTO(text: 'Import 1 text', id: 1),
        ImportDTO(text: 'Import 2 text', id: 2)
      ]);

      await tester.pumpWidget(importsPage(importsPageScaffoldKey));
      await tester.pumpAndSettle();

      expect(find.byType(ListTile), findsNWidgets(2));
      expect(find.text('Import 1 text'), findsOneWidget);
      expect(find.text('Import 2 text'), findsOneWidget);
    });

    testWidgets('should display floating button', (WidgetTester tester) async {
      stubImportsResponse(httpClient, []);

      await tester.pumpWidget(importsPage(importsPageScaffoldKey));
      await tester.pumpAndSettle();

      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('taping floating action button should open CreateImportPage',
        (WidgetTester tester) async {
      stubImportsResponse(httpClient, []);
      await tester.pumpWidget(importsPage(importsPageScaffoldKey));
      await tester.pumpAndSettle(); // TODO: try removing line

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.byType(CreateImportPage), findsOneWidget);
    });
  });
}
