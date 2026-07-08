import '../../../core/network/api_client.dart';

class PersonaChatApi {
  Future<ActivePersona> getActivePersona() async {
    final response = await ApiClient.dio.get('/personas/active');
    final data = response.data['data'];

    if (data == null) {
      throw Exception('active persona data가 없습니다.');
    }

    return ActivePersona.fromJson(Map<String, dynamic>.from(data));
  }

  Future<ConversationSession> createConversation({
    required String personaId,
    String channel = 'TEXT',
    String title = '페르소나 대화',
  }) async {
    final response = await ApiClient.dio.post(
      '/conversations',
      data: {
        'personaId': personaId,
        'channel': channel,
        'title': title,
      },
    );

    final data = response.data['data'];
    if (data == null) {
      throw Exception('conversation data가 없습니다.');
    }

    return ConversationSession.fromJson(Map<String, dynamic>.from(data));
  }

  Future<PersonaMessageResponse> sendTextMessage({
    required String conversationId,
    required String content,
  }) async {
    final response = await ApiClient.dio.post(
      '/conversations/$conversationId/messages/text',
      data: {
        'content': content,
      },
    );

    final data = response.data['data'];
    if (data == null) {
      throw Exception('message response data가 없습니다.');
    }

    return PersonaMessageResponse.fromJson(Map<String, dynamic>.from(data));
  }
}

class ActivePersona {
  final String id;
  final String displayName;
  final String description;
  final String? profileImageUrl;
  final String voiceId;
  final String modelId;
  final bool isActive;

  ActivePersona({
    required this.id,
    required this.displayName,
    required this.description,
    required this.profileImageUrl,
    required this.voiceId,
    required this.modelId,
    required this.isActive,
  });

  factory ActivePersona.fromJson(Map<String, dynamic> json) {
    return ActivePersona(
      id: json['id'] ?? '',
      displayName: json['displayName'] ?? '',
      description: json['description'] ?? '',
      profileImageUrl: json['profileImageUrl'],
      voiceId: json['voiceId'] ?? '',
      modelId: json['modelId'] ?? '',
      isActive: json['isActive'] ?? false,
    );
  }
}

class ConversationSession {
  final String id;
  final String personaId;
  final String channel;
  final String title;

  ConversationSession({
    required this.id,
    required this.personaId,
    required this.channel,
    required this.title,
  });

  factory ConversationSession.fromJson(Map<String, dynamic> json) {
    return ConversationSession(
      id: json['id'] ?? json['conversationId'] ?? '',
      personaId: json['personaId'] ?? '',
      channel: json['channel'] ?? 'TEXT',
      title: json['title'] ?? '',
    );
  }
}

class PersonaMessageResponse {
  final ChatMessageData userMessage;
  final ChatMessageData assistantMessage;

  PersonaMessageResponse({
    required this.userMessage,
    required this.assistantMessage,
  });

  factory PersonaMessageResponse.fromJson(Map<String, dynamic> json) {
    return PersonaMessageResponse(
      userMessage: ChatMessageData.fromJson(
        Map<String, dynamic>.from(json['userMessage'] ?? {}),
      ),
      assistantMessage: ChatMessageData.fromJson(
        Map<String, dynamic>.from(json['assistantMessage'] ?? {}),
      ),
    );
  }
}

class ChatMessageData {
  final String id;
  final String content;
  final String inputMode;
  final String? ttsAudioUrl;

  ChatMessageData({
    required this.id,
    required this.content,
    required this.inputMode,
    this.ttsAudioUrl,
  });

  factory ChatMessageData.fromJson(Map<String, dynamic> json) {
    return ChatMessageData(
      id: json['id'] ?? '',
      content: json['content'] ?? '',
      inputMode: json['inputMode'] ?? 'TEXT',
      ttsAudioUrl: json['ttsAudioUrl'],
    );
  }
}