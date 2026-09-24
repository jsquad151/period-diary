import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:share_plus/share_plus.dart';

class GatewayFile {
  const GatewayFile(this.name, this.bytes, this.mimeType);
  GatewayFile.text(this.name, String text, this.mimeType) : bytes = Uint8List.fromList(utf8.encode(text));

  final String name;
  final Uint8List bytes;
  final String mimeType;
}

/// The only place that talks to the phone's file pickers and share sheet,
/// so the rest of the app (and tests) never depend on platform plugins.
abstract class FileGateway {
  /// Asks the user where to save [file]. Returns false if they cancelled.
  Future<bool> saveFile(GatewayFile file);

  /// Opens the system share sheet with [files].
  Future<void> shareFiles(List<GatewayFile> files);

  /// Lets the user pick a file and returns its text, or null if cancelled.
  Future<String?> pickText();
}

class PluginFileGateway implements FileGateway {
  const PluginFileGateway();

  @override
  Future<bool> saveFile(GatewayFile file) async {
    final uri = await FilePicker.saveFile(
      fileName: file.name,
      bytes: file.bytes,
      mimeType: file.mimeType,
    );
    return uri != null;
  }

  @override
  Future<void> shareFiles(List<GatewayFile> files) async {
    await SharePlus.instance.share(ShareParams(
      files: [
        for (final f in files) XFile.fromData(f.bytes, mimeType: f.mimeType, name: f.name),
      ],
      fileNameOverrides: [for (final f in files) f.name],
    ));
  }

  @override
  Future<String?> pickText() async {
    final file = await FilePicker.pickFile();
    if (file == null) return null;
    return utf8.decode(await file.readAsBytes());
  }
}
