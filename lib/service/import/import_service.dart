import 'package:get_it/get_it.dart';

import '../../api/glas_http_client.dart';
import '../../api/glas_import/dto/create_import_dto.dart';

class ImportService {
  final GlasHttpClient httpClient = GetIt.instance.get<GlasHttpClient>();

  Future<void> createImport(String text) async {
    final response =
        await httpClient.post('imports', CreateImportDTO(text: text).toJson());

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to create import: ${response.statusCode}');
    }
  }
}
