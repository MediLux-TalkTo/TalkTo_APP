import 'package:flutter/material.dart';

import '../data/persona_chat_api.dart';
import './widgets/voiceplaybutton.dart';

class PersonaChatScreen extends StatefulWidget {
  final String name;
  final String imageUrl;
  final String learningText;

  const PersonaChatScreen({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.learningText,
  });

  @override
  State<PersonaChatScreen> createState() => _PersonaChatScreenState();
}

class _PersonaChatScreenState extends State<PersonaChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final PersonaChatApi _api = PersonaChatApi();

  String? _conversationId;
  bool _isLoading = true;
  bool _isSending = false;
  String? _errorMessage;

  final List<_ChatMessage> _messages = [
    _ChatMessage(text: '우리 아들, 오늘은 어쩐 일이야?\n밥은 먹었고?', isMe: false),
  ];

  final List<String> _suggestions = [
    '김치 어떻게 담가요?',
    '엄마 고향 이야기 해줘요',
    '요즘 고민이 있어요',
  ];

  String buildAudioUrl(String? url) {
    if (url == null || url.isEmpty) {
      return '';
    }

    if (url.startsWith('http')) {
      return url;
    }

    return 'https://talkto-personaai-be.onrender.com$url';
  }

  Future<void> _sendMessage(String text) async {
    final value = text.trim();
    if (value.isEmpty || _isSending) return;

    if (_conversationId == null || _conversationId!.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('대화 세션이 아직 준비되지 않았습니다.')));
      return;
    }

    setState(() {
      _messages.add(_ChatMessage(text: value, isMe: true));
      _controller.clear();
      _isSending = true;
    });

    try {
      final result = await _api.sendTextMessage(
        conversationId: _conversationId!,
        content: value,
      );

      final audioUrl = buildAudioUrl(result.assistantMessage.ttsAudioUrl);

      setState(() {
        _messages.add(
          _ChatMessage(
            text: result.assistantMessage.content,
            isMe: false,
            audioUrl: audioUrl,
          ),
        );
      });
    } catch (e) {
      setState(() {
        _messages.add(
          const _ChatMessage(
            text: '답변을 불러오지 못했어요. 잠시 후 다시 시도해주세요.',
            isMe: false,
          ),
        );
      });
    } finally {
      setState(() {
        _isSending = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    try {
      final activePersona = await _api.getActivePersona();

      final conversation = await _api.createConversation(
        personaId: activePersona.id,
        channel: 'TEXT',
        title: '${widget.name}와의 대화',
      );

      setState(() {
        _conversationId = conversation.id;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = '대화를 시작하지 못했습니다. $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FFF5),
      body: SafeArea(
        child: Column(
          children: [
            _ChatHeader(
              name: widget.name,
              imageUrl: widget.imageUrl,
              learningText: widget.learningText,
            ),

            if (_isLoading)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            else if (_errorMessage != null)
              Expanded(child: Center(child: Text(_errorMessage!)))
            else
              Expanded(
                child: Stack(
                  children: [
                    const _SoftBackground(),
                    ListView(
                      padding: const EdgeInsets.fromLTRB(24, 22, 24, 120),
                      children: [
                        const Center(
                          child: _InfoChip(text: '어머니의 실제 통화 녹음을 학습해 말투를 재현해요'),
                        ),
                        const SizedBox(height: 16),
                        ..._messages.map(
                          (message) => Column(
                            crossAxisAlignment: message.isMe
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              _MessageBubble(message: message),
                              if (!message.isMe)
                                VoicePlayButton(
                                  voiceUrl: message.audioUrl,
                                  label: '${widget.name} 목소리로 듣기',
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            _ChatInputArea(
              controller: _controller,
              suggestions: _suggestions,
              isSending: _isSending,
              onSend: _sendMessage,
              onSuggestionTap: _sendMessage,
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatHeader extends StatelessWidget {
  final String name;
  final String imageUrl;
  final String learningText;

  const _ChatHeader({
    required this.name,
    required this.imageUrl,
    required this.learningText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 126,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE5E5E5))),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          ),
          CircleAvatar(radius: 28, backgroundImage: NetworkImage(imageUrl)),
          const SizedBox(width: 14),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '$name \n',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF222222),
                    ),
                  ),
                  TextSpan(
                    text: learningText,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF8A8A8A),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFFC85C),
              borderRadius: BorderRadius.circular(100),
            ),
            child: const Text(
              '✧ AI',
              style: TextStyle(
                fontSize: 13,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final _ChatMessage message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 280),
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: message.isMe ? const Color(0xFF4DDC97) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: message.isMe
              ? null
              : Border.all(color: const Color(0xFFEFE7DF)),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            fontSize: 17,
            height: 1.5,
            color: message.isMe ? Colors.white : const Color(0xFF222222),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _ChatInputArea extends StatelessWidget {
  final TextEditingController controller;
  final List<String> suggestions;
  final ValueChanged<String> onSend;
  final ValueChanged<String> onSuggestionTap;
  final bool isSending;

  const _ChatInputArea({
    required this.controller,
    required this.suggestions,
    required this.onSend,
    required this.onSuggestionTap,
    required this.isSending,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF8FFF5),
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 18),
      child: Column(
        children: [
          SizedBox(
            height: 38,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: suggestions.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final suggestion = suggestions[index];

                return GestureDetector(
                  onTap: () => onSuggestionTap(suggestion),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE3F8ED),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      suggestion,
                      style: const TextStyle(
                        color: Color(0xFF009F65),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 56,
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: const Color(0xFFE5E5E5)),
                  ),
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: '엄마에게 하고 싶은 말...',
                      border: InputBorder.none,
                    ),
                    onSubmitted: onSend,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: isSending ? null : () => onSend(controller.text),
                child: Container(
                  width: 58,
                  height: 58,
                  decoration: const BoxDecoration(
                    color: Color(0xFF4DDC97),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.send_rounded,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String text;

  const _InfoChip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: const Color(0xFFE5E5E5)),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12, color: Color(0xFF8A8A8A)),
      ),
    );
  }
}

class _SoftBackground extends StatelessWidget {
  const _SoftBackground();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Center(
        child: Opacity(
          opacity: 0.12,
          child: Icon(
            Icons.local_florist_outlined,
            size: 220,
            color: const Color(0xFFFFA982),
          ),
        ),
      ),
    );
  }
}

class _ChatMessage {
  final String text;
  final bool isMe;
  final String? audioUrl;

  const _ChatMessage({required this.text, required this.isMe, this.audioUrl});
}
