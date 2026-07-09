import '../../../core/network/api_client.dart';

class SubjectApi {
  Future<List<Subject>> getSubjects() async {
    final response = await ApiClient.dio.get('/subjects');
    final data = response.data['data'];

    if (data == null) return [];

    return (data as List)
        .map((e) => Subject.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}

class Subject {
  final String id;
  final String displayName;
  final String relationship;
  final String relationshipLabel;
  final String lifeStatus;
  final String? regionText;
  final String? notes;
  final int recordingCount;
  final int recordingSeconds;
  final String memoriesStatus;
  final String personaStatus;

  Subject({
    required this.id,
    required this.displayName,
    required this.relationship,
    required this.relationshipLabel,
    required this.lifeStatus,
    required this.regionText,
    required this.notes,
    required this.recordingCount,
    required this.recordingSeconds,
    required this.memoriesStatus,
    required this.personaStatus,
  });

  bool get isAlive => lifeStatus == 'LIVING';

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id: json['id'] ?? '',
      displayName: json['displayName'] ?? '',
      relationship: json['relationship'] ?? '',
      relationshipLabel: json['relationshipLabel'] ?? json['displayName'] ?? '',
      lifeStatus: json['lifeStatus'] ?? 'LIVING',
      regionText: json['regionText'],
      notes: json['notes'],
      recordingCount: json['recordingCount'] ?? 0,
      recordingSeconds: json['recordingSeconds'] ?? 0,
      memoriesStatus: json['memoriesStatus'] ?? 'NOT_STARTED',
      personaStatus: json['personaStatus'] ?? 'NOT_STARTED',
    );
  }
}
