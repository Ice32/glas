import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:glas_client/api/glas_http_client.dart';
import 'package:glas_client/api/glas_import/dto/my_word_dto.dart';
import 'package:glas_client/screens/my_words_page.dart';
import 'package:glas_client/service/import/my_words_service.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'my_words_page_widget_test.mocks.dart';

final getIt = GetIt.instance;

MaterialApp myWordsPage(GlobalKey<ScaffoldState> myWordsPageScaffoldKey) {
  return MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: MyWordsPage(
      key: myWordsPageScaffoldKey,
    ),
  );
}

void stubMyWordsResponse(
    MockGlasHttpClient httpClient, List<MyWordDTO> myWords) {
  when(httpClient.get('my-words', any)).thenAnswer((realInvocation) =>
      Future.value(http.Response(jsonEncode(myWords), 200)));
}

@GenerateNiceMocks([MockSpec<GlasHttpClient>()])
void main() {
  final myWordsPageScaffoldKey = GlobalKey<ScaffoldState>();
  late MockGlasHttpClient httpClient;

  setUp(() {
    var glasHttpClient = MockGlasHttpClient();
    getIt.registerSingleton<GlasHttpClient>(glasHttpClient);
    getIt.registerSingleton<MyWordsService>(MyWordsService());
    httpClient = glasHttpClient;
  });

  tearDown(() {
    getIt.reset();
  });

  group('My words page widget test', () {
    testWidgets('should render my words', (WidgetTester tester) async {
      stubMyWordsResponse(httpClient, [
        const MyWordDTO(text: 'Word1', id: 1),
        const MyWordDTO(text: 'Word2', id: 2)
      ]);

      await tester.pumpWidget(myWordsPage(myWordsPageScaffoldKey));
      await tester.pumpAndSettle();

      expect(find.byType(ListTile), findsNWidgets(2));
      expect(find.text('Word1'), findsOneWidget);
      expect(find.text('Word2'), findsOneWidget);
    });
  });
}
