import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class VoicePlayButton extends StatefulWidget {
  final String? voiceUrl;
  final String label;

  const VoicePlayButton({
    super.key,
    required this.voiceUrl,
    required this.label,
  });

  @override
  State<VoicePlayButton> createState() => _VoicePlayButtonState();
}

class _VoicePlayButtonState extends State<VoicePlayButton> {
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;

  Future<void> _play() async {
    if (widget.voiceUrl == null || widget.voiceUrl!.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('아직 음성 파일이 없어요.')));
      return;
    }

    if (_isPlaying) {
      await _player.stop();
      setState(() => _isPlaying = false);
      return;
    }

    setState(() => _isPlaying = true);
    await _player.play(UrlSource(widget.voiceUrl!));
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: _play,
        child: Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF0EA),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Text(
            _isPlaying ? '재생 중...' : '▶ ${widget.label}',
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFFFF8A65),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
