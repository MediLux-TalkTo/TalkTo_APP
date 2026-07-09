import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:mime/mime.dart';

class RecordingUploadService {
  final Dio _dio = Dio();

  Future<void> uploadToPresignedUrl({
    required String uploadUrl,
    required PlatformFile file,
    required String mimeType,
    void Function(int sentBytes, int totalBytes)? onSendProgress,
  }) async {
    if (uploadUrl.isEmpty) {
      throw Exception('uploadUrl이 비어 있습니다.');
    }

    final bytes = file.bytes;

    if (bytes == null) {
      throw Exception(
        '웹에서는 file.bytes가 필요합니다. pickFiles에서 withData: true로 설정하세요.',
      );
    }

    await _dio.put(
      uploadUrl,
      data: bytes,
      options: Options(
        headers: {'Content-Type': mimeType},
        responseType: ResponseType.plain,
      ),
      onSendProgress: onSendProgress,
    );
  }

  Future<void> _uploadBytes({
    required String uploadUrl,
    required Uint8List bytes,
    required String mimeType,
    void Function(int sentBytes, int totalBytes)? onSendProgress,
  }) async {
    await _dio.put(
      uploadUrl,
      data: Stream.fromIterable([bytes]),
      options: Options(
        headers: {'Content-Type': mimeType, 'Content-Length': bytes.length},
        responseType: ResponseType.plain,
      ),
      onSendProgress: onSendProgress,
    );
  }

  Future<void> _uploadFilePath({
    required String uploadUrl,
    required String filePath,
    required String mimeType,
    void Function(int sentBytes, int totalBytes)? onSendProgress,
  }) async {
    await _dio.put(
      uploadUrl,
      data: await MultipartFile.fromFile(filePath),
      options: Options(
        headers: {'Content-Type': mimeType},
        responseType: ResponseType.plain,
      ),
      onSendProgress: onSendProgress,
    );
  }

  String detectMimeType(PlatformFile file) {
    final fromName = lookupMimeType(file.name);
    if (fromName != null) return fromName;

    final path = file.path;
    if (path != null) {
      final fromPath = lookupMimeType(path);
      if (fromPath != null) return fromPath;
    }

    return 'audio/mp4';
  }

  String platformName() {
    return 'app';
  }

  String getPlatformName() {
    if (kIsWeb) return 'web';
    if (Platform.isIOS) return 'ios';
    if (Platform.isAndroid) return 'android';
    if (Platform.isMacOS) return 'macos';
    if (Platform.isWindows) return 'windows';
    return 'unknown';
  }
}
