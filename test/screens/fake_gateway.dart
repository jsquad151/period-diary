import 'package:period_diary/data/file_gateway.dart';

/// Records what the app tried to save/share and serves a canned import file.
class FakeFileGateway implements FileGateway {
  final List<GatewayFile> saved = [];
  final List<List<GatewayFile>> shared = [];
  String? pickResult;
  bool saveCancelled = false;

  @override
  Future<bool> saveFile(GatewayFile file) async {
    if (saveCancelled) return false;
    saved.add(file);
    return true;
  }

  @override
  Future<void> shareFiles(List<GatewayFile> files) async => shared.add(files);

  @override
  Future<String?> pickText() async => pickResult;
}
