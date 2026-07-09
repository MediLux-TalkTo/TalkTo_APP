import '../../../core/network/api_client.dart';

class RecordingApi {
  Future<UploadIntentResponse> createUploadIntent({
    required String subjectId,
    required String originalFilename,
    required String mimeType,
    required int fileSizeBytes,
    int? durationSeconds,
    String? memo,
    String? conversationPartnerName,
    String? relatedQuestionId,
    String? relatedQuestionText,
    String? fileHash,
    String source = 'app_recording',
    String platform = 'ios',
    bool singleFile = true,
  }) async {
    final response = await ApiClient.dio.post(
      '/recordings/upload-intent',
      data: {
        'subjectId': subjectId,
        'originalFilename': originalFilename,
        'mimeType': mimeType,
        'fileSizeBytes': fileSizeBytes,
        if (durationSeconds != null) 'durationSeconds': durationSeconds,
        if (memo != null && memo.isNotEmpty) 'memo': memo,
        if (conversationPartnerName != null &&
            conversationPartnerName.isNotEmpty)
          'conversationPartnerName': conversationPartnerName,
        if (relatedQuestionId != null && relatedQuestionId.isNotEmpty)
          'relatedQuestionId': relatedQuestionId,
        if (relatedQuestionText != null && relatedQuestionText.isNotEmpty)
          'relatedQuestionText': relatedQuestionText,
        if (fileHash != null && fileHash.isNotEmpty) 'fileHash': fileHash,
        'source': source,
        'platform': platform,
        'singleFile': singleFile,
      },
    );

    final data = response.data['data'];
    if (data == null) {
      throw Exception('upload intent data가 없습니다.');
    }

    return UploadIntentResponse.fromJson(Map<String, dynamic>.from(data));
  }

  Future<void> completeUpload({
    required String recordingId,
    required String uploadIntentId,
    String? fileHash,
  }) async {
    await ApiClient.dio.post(
      '/recordings/$recordingId/complete',
      data: {
        'uploadIntentId': uploadIntentId,
        if (fileHash != null && fileHash.isNotEmpty) 'fileHash': fileHash,
      },
    );
  }

  Future<List<Recording>> getRecordings(String subjectId) async {
    final response = await ApiClient.dio.get('/subjects/$subjectId/recordings');

    final data = response.data['data'];

    if (data is List) {
      return data.map((e) => Recording.fromJson(e)).toList();
    }

    return [];
  }
}

class UploadIntentResponse {
  final Recording recording;
  final String method;
  final String uploadUrl;
  final String storageKey;
  final String expiresAt;
  final String uploadIntentId;
  final String status;
  final String source;
  final String platform;
  final bool singleFile;
  final String? failureCode;

  UploadIntentResponse({
    required this.recording,
    required this.method,
    required this.uploadUrl,
    required this.storageKey,
    required this.expiresAt,
    required this.uploadIntentId,
    required this.status,
    required this.source,
    required this.platform,
    required this.singleFile,
    this.failureCode,
  });

  factory UploadIntentResponse.fromJson(Map<String, dynamic> json) {
    return UploadIntentResponse(
      recording: Recording.fromJson(
        Map<String, dynamic>.from(json['recording'] ?? {}),
      ),
      method: json['method'] ?? 'PUT',
      uploadUrl: json['uploadUrl'] ?? '',
      storageKey: json['storageKey'] ?? '',
      expiresAt: json['expiresAt'] ?? '',
      uploadIntentId: json['uploadIntentId'] ?? '',
      status: json['status'] ?? '',
      source: json['source'] ?? '',
      platform: json['platform'] ?? '',
      singleFile: json['singleFile'] ?? true,
      failureCode: json['failureCode'],
    );
  }
}

class Recording {
  final String id;
  final String subjectId;
  final String originalFilename;
  final String mimeType;
  final int fileSizeBytes;
  final int? durationSeconds;
  final String uploadStatus;
  final String analysisStatus;
  final String archiveStatus;
  final String analysisStage;
  final String memoriesStatus;
  final String checksumStatus;
  final String? memo;
  final String? conversationPartnerName;
  final String? relatedQuestionId;
  final String? relatedQuestionText;
  final int recordingCount;
  final int totalRecordingSeconds;
  final String statusBadge;
  final String memoriesCta;
  final String? summary;
  final String summaryStatus;
  final String uploadedAt;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  Recording({
    required this.id,
    required this.subjectId,
    required this.originalFilename,
    required this.mimeType,
    required this.fileSizeBytes,
    required this.durationSeconds,
    required this.uploadStatus,
    required this.analysisStatus,
    required this.archiveStatus,
    required this.analysisStage,
    required this.memoriesStatus,
    required this.checksumStatus,
    required this.memo,
    required this.conversationPartnerName,
    required this.relatedQuestionId,
    required this.relatedQuestionText,
    required this.recordingCount,
    required this.totalRecordingSeconds,
    required this.statusBadge,
    required this.memoriesCta,
    required this.summary,
    required this.summaryStatus,
    required this.uploadedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory Recording.fromJson(Map<String, dynamic> json) {
    return Recording(
      id: json['id'] ?? '',
      subjectId: json['subject_id'] ?? json['subjectId'] ?? '',
      originalFilename:
          json['original_filename'] ?? json['originalFilename'] ?? '',
      mimeType: json['mime_type'] ?? json['mimeType'] ?? '',
      fileSizeBytes: _toInt(json['file_size_bytes'] ?? json['fileSizeBytes']),
      durationSeconds:
          json['duration_seconds'] == null && json['durationSeconds'] == null
          ? null
          : _toInt(json['duration_seconds'] ?? json['durationSeconds']),
      uploadStatus: json['upload_status'] ?? json['uploadStatus'] ?? '',
      analysisStatus: json['analysis_status'] ?? json['analysisStatus'] ?? '',
      archiveStatus: json['archive_status'] ?? json['archiveStatus'] ?? '',
      analysisStage: json['analysis_stage'] ?? json['analysisStage'] ?? '',
      memoriesStatus: json['memories_status'] ?? json['memoriesStatus'] ?? '',
      checksumStatus: json['checksum_status'] ?? json['checksumStatus'] ?? '',
      memo: json['memo'],
      conversationPartnerName:
          json['conversation_partner_name'] ?? json['conversationPartnerName'],
      relatedQuestionId:
          json['related_question_id'] ?? json['relatedQuestionId'],
      relatedQuestionText:
          json['related_question_text'] ?? json['relatedQuestionText'],
      recordingCount: _toInt(json['recording_count'] ?? json['recordingCount']),
      totalRecordingSeconds: _toInt(
        json['total_recording_seconds'] ?? json['totalRecordingSeconds'],
      ),
      statusBadge: json['status_badge'] ?? json['statusBadge'] ?? '',
      memoriesCta: json['memories_cta'] ?? json['memoriesCta'] ?? '',
      summary: json['summary'],
      summaryStatus: json['summary_status'] ?? json['summaryStatus'] ?? '',
      uploadedAt: json['uploaded_at'] ?? json['uploadedAt'] ?? '',
      createdAt: json['created_at'] ?? json['createdAt'] ?? '',
      updatedAt: json['updated_at'] ?? json['updatedAt'] ?? '',
      deletedAt: json['deleted_at'] ?? json['deletedAt'],
    );
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}
