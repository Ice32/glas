import 'dart:convert';

import 'package:get_it/get_it.dart';

import '../../api/glas_http_client.dart';
import '../../api/glas_import/dto/create_import_dto.dart';
import '../../api/glas_import/dto/import_dto.dart';

class ImportService {
  final GlasHttpClient httpClient = GetIt.instance.get<GlasHttpClient>();

  Future<void> createImport(String text) async {
    final response =
        await httpClient.post('imports', CreateImportDTO(text: text).toJson());

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to create import: ${response.statusCode}');
    }
  }

  Future<List<ImportDTO>> getImports() async {
    final response = await httpClient.get('imports');
    final imports = jsonDecode(response.body) as List;
    return imports.map((i) => ImportDTO.fromJson(i)).toList();
  }
}
