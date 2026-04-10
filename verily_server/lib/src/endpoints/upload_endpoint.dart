import 'package:serverpod/serverpod.dart';

/// Endpoint for managing file uploads to cloud storage.
///
/// Uses Serverpod's built-in cloud storage with direct upload support.
/// The flow is:
/// 1. Client calls [getUploadDescription] to get a signed upload URL
/// 2. Client uploads the file directly to the URL
/// 3. Client calls [verifyUpload] to confirm the upload succeeded
/// 4. Server returns the public URL for the uploaded file
class UploadEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Generates a signed upload description for direct file upload.
  ///
  /// [path] is the storage path (e.g., `submissions/video_123.mp4`).
  /// Returns a JSON string with the upload URL and required headers.
  Future<String?> getUploadDescription(Session session, String path) async {
    return session.storage.createDirectFileUploadDescription(
      storageId: 'public',
      path: path,
    );
  }

  /// Verifies that a direct file upload completed successfully.
  ///
  /// Call this after the client finishes uploading the file.
  /// Returns `true` if the file is stored and accessible.
  Future<bool> verifyUpload(Session session, String path) async {
    return session.storage.verifyDirectFileUpload(
      storageId: 'public',
      path: path,
    );
  }

  /// Returns the public URL for an uploaded file.
  ///
  /// Returns `null` if the file does not exist.
  Future<Uri?> getPublicUrl(Session session, String path) async {
    return session.storage.getPublicUrl(storageId: 'public', path: path);
  }
}
