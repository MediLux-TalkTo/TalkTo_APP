import '../../../core/network/api_client.dart';

class SubjectApi {
  Future<Map<String, dynamic>> createSubject({
    required String displayName,
    required String relationship,
    required String lifeStatus,
    String? localeHint,
    String? dialectHint,
    String? notes,
  }) async {
    final response = await ApiClient.dio.post(
      '/subjects',
      data: {
        'displayName': displayName,
        'relationship': relationship,
        'lifeStatus': lifeStatus,
        if (localeHint != null) 'localeHint': localeHint,
        if (dialectHint != null) 'dialectHint': dialectHint,
        if (notes != null) 'notes': notes,
      },
    );

    return Map<String, dynamic>.from(response.data);
  }
}