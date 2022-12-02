import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:glas_client/api/glas_http_client.dart';
import 'package:glas_client/screens/create_import_page.dart';
import 'package:glas_client/screens/imports_page.dart';
import 'package:glas_client/service/import/import_service.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'create_import_page_widget_test.mocks.dart';

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
    testWidgets('should render text fields and button',
        (WidgetTester tester) async {
      await tester.pumpWidget(importPage(importPageScaffoldKey));

      expect(find.byKey(const Key("importTextField")), findsOneWidget);
      expect(find.byKey(const Key("importTitleField")), findsOneWidget);
      expect(find.text('Import'), findsNWidgets(2));
    });

    testWidgets('should submit correct values', (WidgetTester tester) async {
      const importText = "a text import";
      const importTitle = "an import title";
      when(httpClient.post('imports', any))
          .thenAnswer((realInvocation) => Future.value(http.Response('', 204)));
      await tester.pumpWidget(importPage(importPageScaffoldKey));
      await tester.enterText(
          find.byKey(const Key("importTextField")), importText);
      await tester.enterText(
          find.byKey(const Key("importTitleField")), importTitle);

      await tester.tap(find.byKey(const Key('submitButton')));
      await tester.pump();

      verify(httpClient
          .post('imports', {'text': importText, 'title': importTitle}));
    });

    testWidgets('should navigate to imports page', (WidgetTester tester) async {
      when(httpClient.post('imports', any))
          .thenAnswer((realInvocation) => Future.value(http.Response('', 204)));
      when(httpClient.get('imports')).thenAnswer(
          (realInvocation) => Future.value(http.Response('[]', 200)));
      await tester.pumpWidget(importPage(importPageScaffoldKey));
      await tester.enterText(
          find.byKey(const Key("importTitleField")), "a text import");
      await tester.enterText(
          find.byKey(const Key("importTextField")), "a text import");

      await tester.tap(find.byKey(const Key('submitButton')));
      await tester.pumpAndSettle();

      expect(find.byType(ImportsPage), findsOneWidget);
    });

    testWidgets('should display snackbar message if request fails',
        (WidgetTester tester) async {
      when(httpClient.post('imports', any))
          .thenAnswer((realInvocation) => Future.value(http.Response('', 400)));
      await tester.pumpWidget(importPage(importPageScaffoldKey));
      await tester.enterText(
          find.byKey(const Key("importTitleField")), "a text import");
      await tester.enterText(
          find.byKey(const Key("importTextField")), "a text import");

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
      await tester.enterText(
          find.byKey(const Key("importTextField")), importText);

      await tester.tap(find.byKey(const Key('submitButton')));
      await tester.pump();

      expect(find.text(importText), findsOneWidget);
    });

    testWidgets('should display validation error if import text empty',
        (WidgetTester tester) async {
      when(httpClient.post('imports', any))
          .thenAnswer((realInvocation) => Future.value(http.Response('', 400)));
      await tester.pumpWidget(importPage(importPageScaffoldKey));

      await tester.tap(find.byKey(const Key('submitButton')));
      await tester.pump();

      expect(find.text("Import text can't be empty"), findsOneWidget);
    });

    testWidgets('should display validation error if import title empty',
        (WidgetTester tester) async {
      when(httpClient.post('imports', any))
          .thenAnswer((realInvocation) => Future.value(http.Response('', 400)));
      await tester.pumpWidget(importPage(importPageScaffoldKey));

      await tester.tap(find.byKey(const Key('submitButton')));
      await tester.pump();

      expect(find.text("Import title can't be empty"), findsOneWidget);
    });
  });
}
