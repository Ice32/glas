import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:glas_client/api/glas_http_client.dart';
import 'package:glas_client/screens/create_import_page.dart';
import 'package:glas_client/service/import/import_service.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../create_import_page_widget_test.mocks.dart';

final getIt = GetIt.instance;

MaterialApp importPage(GlobalKey<ScaffoldState> importPageScaffoldKey) {
  return MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: CreateImportPage(
      key: importPageScaffoldKey,
    ),
  );
}

@GenerateNiceMocks([MockSpec<GlasHttpClient>()])
void main() {
  final importPageScaffoldKey = GlobalKey<ScaffoldState>();
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

  testWidgets('Create import page - golden', (WidgetTester tester) async {
    when(httpClient.post('imports', any))
        .thenAnswer((realInvocation) => Future.value(http.Response('', 204)));
    await tester.pumpWidget(importPage(importPageScaffoldKey));

    await expectLater(find.byType(CreateImportPage),
        matchesGoldenFile('createImportPage.png'));
  });
}
