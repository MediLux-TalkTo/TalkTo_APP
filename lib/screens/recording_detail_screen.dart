import 'package:flutter/material.dart';

import 'archive_screen.dart';

class RecordingDetailScreen extends StatelessWidget {
  final RecordingItem record;

  const RecordingDetailScreen({super.key, required this.record});

  static const Color primary = Color(0xFF22CC7A);
  static const Color subText = Color(0xFF7C8273);
  static const Color darkText = Color(0xFF222222);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFCF8),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 38, 24, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  const CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(
                      'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '${record.person} · ${record.date} (일)\n',
                          style: const TextStyle(fontSize: 14, color: subText),
                        ),
                        TextSpan(
                          text: record.tag,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF009F65),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 26),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      record.title,
                      style: const TextStyle(
                        fontSize: 24,
                        height: 1.3,
                        fontWeight: FontWeight.w700,
                        color: darkText,
                      ),
                    ),
                  ),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: const Color(0xFFEDE7DF)),
                    ),
                    child: const Icon(
                      Icons.edit_outlined,
                      size: 21,
                      color: subText,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              const _AudioPlayerBox(),
              const SizedBox(height: 22),
              const _PremiumSummaryBox(),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 58,
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.delete_outline_rounded, size: 20),
                  label: const Text(
                    '이 기록 삭제',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFE55353),
                    side: const BorderSide(color: Color(0xFFE55353)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AudioPlayerBox extends StatelessWidget {
  const _AudioPlayerBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 118,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: Color(0xFFFFA982),
            child: Icon(
              Icons.play_arrow_rounded,
              color: Colors.white,
              size: 34,
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomPaint(
                  size: const Size(double.infinity, 40),
                  painter: _WaveformPainter(),
                ),
                const SizedBox(height: 4),
                Row(
                  children: const [
                    Text(
                      '00:00',
                      style: TextStyle(
                        fontSize: 13,
                        color: RecordingDetailScreen.subText,
                      ),
                    ),
                    Spacer(),
                    Text(
                      '12:34',
                      style: TextStyle(
                        fontSize: 13,
                        color: RecordingDetailScreen.subText,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PremiumSummaryBox extends StatelessWidget {
  const _PremiumSummaryBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 136,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3D9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFDFA3)),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFFFFC85C),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.workspace_premium_outlined,
              color: Colors.white,
              size: 26,
            ),
          ),
          const SizedBox(width: 18),
          const Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '이 통화엔 어떤 이야기가 담겼을까요\n',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF5C4630),
                    ),
                  ),
                  TextSpan(
                    text:
                        '메모리 검색을 켜면 AI가 전사, 요약한 통화를\n바탕으로 원하는 내용을 검색해 볼 수 있어요.',
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.6,
                      color: Color(0xFF9A7A45),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WaveformPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFFB08C)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final heights = [
      12,
      24,
      14,
      30,
      18,
      22,
      34,
      15,
      28,
      20,
      36,
      16,
      25,
      30,
      14,
      20,
      32,
      18,
      26,
      35,
      16,
      22,
      28,
      14,
      24,
      32,
    ];

    final gap = size.width / heights.length;

    for (int i = 0; i < heights.length; i++) {
      final x = i * gap;
      final h = heights[i].toDouble();
      final y1 = (size.height - h) / 2;
      final y2 = y1 + h;

      canvas.drawLine(Offset(x, y1), Offset(x, y2), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
