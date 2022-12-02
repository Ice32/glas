import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:glas_client/api/glas_http_client.dart';
import 'package:glas_client/api/glas_import/dto/import_dto.dart';
import 'package:glas_client/service/import/import_service.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'import_service_test.mocks.dart';

final getIt = GetIt.instance;

void stubResponseStatus(MockGlasHttpClient client, int status) {
  when(client.post('imports', any))
      .thenAnswer((realInvocation) => Future.value(http.Response('', status)));
}

@GenerateNiceMocks([MockSpec<GlasHttpClient>()])
void main() {
  group('Import service', () {
    late MockGlasHttpClient client;

    setUp(() {
      var glasHttpClient = MockGlasHttpClient();
      getIt.registerSingleton<GlasHttpClient>(glasHttpClient);
      client = glasHttpClient;
    });

    tearDown(() {
      getIt.reset();
    });

    group('Create import', () {
      test('should call http client', () async {
        when(client.post('imports', any)).thenAnswer(
            (realInvocation) => Future.value(http.Response('', 204)));
        const text = "an import text";
        const title = "an import title";

        await ImportService().createImport(title, text);

        verify(client.post('imports', {'title': title, 'text': text}));
      });

      test('should throw exception if response status less than 200', () async {
        when(client.post('imports', any)).thenAnswer(
            (realInvocation) => Future.value(http.Response('', 199)));

        expect(
            () async => ImportService().createImport('title', 'an import text'),
            throwsException);
      });

      test('should throw exception if response status > 299', () async {
        when(client.post('imports', any)).thenAnswer(
            (realInvocation) => Future.value(http.Response('', 300)));

        expect(
            () async => ImportService().createImport('title', 'an import text'),
            throwsException);
      });
    });

    group('List imports', () {
      test('should return imports', () async {
        List<ImportDTO> imports = [
          ImportDTO(id: 1, title: 'first import', text: 'first import'),
          ImportDTO(id: 2, title: 'second import', text: 'second import'),
        ];
        when(client.get('imports')).thenAnswer((realInvocation) =>
            Future.value(http.Response(jsonEncode(imports), 204)));

        var actual = await ImportService().getImports();

        expect(actual, equals(imports));
      });

      test('should throw exception if response status less than 200', () async {
        when(client.get('imports')).thenAnswer(
            (realInvocation) => Future.value(http.Response('', 199)));

        expect(() async => ImportService().getImports(), throwsException);
      });

      test('should throw exception if response status > 299', () async {
        when(client.get('imports')).thenAnswer(
            (realInvocation) => Future.value(http.Response('', 300)));

        expect(() async => ImportService().getImports(), throwsException);
      });
    });
  });
}
