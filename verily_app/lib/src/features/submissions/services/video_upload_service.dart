import 'dart:io' show File;
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'package:verily_client/verily_client.dart';

/// Uploads a video file to Serverpod cloud storage and returns the public URL.
///
/// Uses Serverpod's built-in [FileUploader] with the upload endpoint:
/// 1. Requests a signed upload description from the server
/// 2. Uploads the file bytes directly
/// 3. Verifies the upload and retrieves the public URL
class VideoUploadService {
  VideoUploadService(this._client);

  final Client _client;

  /// Uploads the video at [videoPath] and returns the public URL.
  ///
  /// [videoPath] is the local file path (mobile) or a blob URL (web).
  /// The file is stored under `submissions/<timestamp>_<hash>.mp4`.
  ///
  /// Returns `null` if the upload fails.
  Future<String?> uploadVideo(String videoPath) async {
    final storagePath =
        'submissions/${DateTime.now().millisecondsSinceEpoch}.mp4';

    // Get upload description from the server.
    final uploadDescription = await _client.upload.getUploadDescription(
      storagePath,
    );
    if (uploadDescription == null) return null;

    // Read file bytes.
    final ByteData byteData;
    if (kIsWeb) {
      final xFile = XFile(videoPath);
      final bytes = await xFile.readAsBytes();
      byteData = ByteData.sublistView(bytes);
    } else {
      final bytes = await File(videoPath).readAsBytes();
      byteData = ByteData.sublistView(bytes);
    }

    // Upload.
    final uploader = FileUploader(uploadDescription);
    final success = await uploader.uploadByteData(byteData);
    if (!success) return null;

    // Verify and get public URL.
    final verified = await _client.upload.verifyUpload(storagePath);
    if (!verified) return null;

    final publicUrl = await _client.upload.getPublicUrl(storagePath);
    return publicUrl?.toString();
  }
}
