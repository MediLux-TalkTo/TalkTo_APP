import '../../../core/network/api_client.dart';

class ConsentApi {
  Future<void> acceptUploadConsents({required String subjectId}) async {
    await ApiClient.dio.post(
      '/consents/accept',
      data: {
        'subject_id': subjectId,
        'consents': [
          {'consent_type': 'privacy_collection', 'version': '2026-06-07'},
          {'consent_type': 'audio_storage_service', 'version': '2026-06-07'},
        ],
      },
    );
  }
}
