import 'dart:convert';

import 'package:get_it/get_it.dart';

import '../../api/glas_http_client.dart';
import '../../api/glas_import/dto/create_import_dto.dart';
import '../../api/glas_import/dto/import_dto.dart';

class ImportService {
  final GlasHttpClient httpClient = GetIt.instance.get<GlasHttpClient>();

  Future<void> createImport(String title, String text) async {
    final response = await httpClient.post(
        'imports', CreateImportDTO(title: title, text: text).toJson());

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to create import: ${response.reasonPhrase}');
    }
  }

  Future<List<ImportDTO>> getImports() async {
    final response = await httpClient.get('imports');

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to retrieve imports: ${response.reasonPhrase}');
    }

    final imports = jsonDecode(response.body) as List;
    return imports.map((i) => ImportDTO.fromJson(i)).toList();
  }
}
