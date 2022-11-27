import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:glas_client/api/glas_http_client.dart';
import 'package:glas_client/screens/create_import_page.dart';
import 'package:glas_client/service/import/import_service.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'import_service_test.mocks.dart';

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

  group('Create import page widget test', () {
    testWidgets('should render text field and button',
        (WidgetTester tester) async {
      await tester.pumpWidget(importPage(importPageScaffoldKey));

      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.text('Import'), findsNWidgets(2));
    });

    testWidgets('should clear input on submit', (WidgetTester tester) async {
      when(httpClient.post('imports', any))
          .thenAnswer((realInvocation) => Future.value(http.Response('', 204)));
      await tester.pumpWidget(importPage(importPageScaffoldKey));

      const importText = "a text import";
      await tester.enterText(find.byType(TextFormField), importText);

      await tester.tap(find.byKey(const Key('submitButton')));
      await tester.pump();

      expect(find.text(importText), findsNothing);
    });

    testWidgets('should display snackbar message if request fails',
        (WidgetTester tester) async {
      when(httpClient.post('imports', any))
          .thenAnswer((realInvocation) => Future.value(http.Response('', 400)));
      await tester.pumpWidget(importPage(importPageScaffoldKey));
      await tester.enterText(find.byType(TextFormField), "a text import");

      await tester.tap(find.byKey(const Key('submitButton')));
      await tester.pump();

      expect(find.text("Unknown error occurred"), findsOneWidget);
    });

    testWidgets('should not clear input on submit if request fails',
        (WidgetTester tester) async {
      when(httpClient.post('imports', any))
          .thenAnswer((realInvocation) => Future.value(http.Response('', 400)));
      await tester.pumpWidget(importPage(importPageScaffoldKey));

      const importText = "a text import";
      await tester.enterText(find.byType(TextFormField), importText);

      await tester.tap(find.byKey(const Key('submitButton')));
      await tester.pump();

      expect(find.text(importText), findsOneWidget);
    });
  });
}
