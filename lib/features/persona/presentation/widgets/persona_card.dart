import 'package:flutter/material.dart';

import '../persona_chat_screen.dart';

class PersonaCard extends StatefulWidget {
  final String name;
  final String imageUrl;
  final String learningText;

  const PersonaCard({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.learningText,
  });

  @override
  State<PersonaCard> createState() => _PersonaCardState();
}

class _PersonaCardState extends State<PersonaCard>
    with TickerProviderStateMixin {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(24, 22, 24, 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.06),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 34,
                  backgroundImage: NetworkImage(widget.imageUrl),
                ),

                const SizedBox(width: 18),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff222222),
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        widget.learningText,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xff909090),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),

            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff22CC7A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PersonaChatScreen(
                        name: widget.name,
                        imageUrl: widget.imageUrl,
                        learningText: widget.learningText,
                      ),
                    ),
                  );
                },
                child: const Text(
                  "보이스 페르소나와 대화하기",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    expanded = !expanded;
                  });
                },
                child: Text(
                  expanded ? '상세보기 접기' : '상세보기',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xff8A8A8A),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            if (expanded) ...[
              const SizedBox(height: 12),

              Row(
                children: const [
                  Expanded(
                    child: _StatCard(value: "12", title: "통화"),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(value: "2h 34m", title: "녹음시간"),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(value: "87%", title: "완성도"),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "주제별 학습도",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
              ),

              const SizedBox(height: 18),

              const _TopicProgress(title: "가족 이야기", percent: .92),

              const SizedBox(height: 12),

              const _TopicProgress(title: "어린 시절", percent: .73),

              const SizedBox(height: 12),

              const _TopicProgress(title: "취미", percent: .45),

              const SizedBox(height: 30),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "자주 하신 말",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                ),
              ),

              const SizedBox(height: 16),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: const [
                  _WordChip("밥 먹었니"),
                  _WordChip("건강"),
                  _WordChip("감기 조심"),
                  _WordChip("김치"),
                  _WordChip("보고싶다"),
                ],
              ),

              const SizedBox(height: 28),

              const RecommendationBox(),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String title;

  const _StatCard({required this.value, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 82,
      decoration: BoxDecoration(
        color: const Color(0xffF7F9F7),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Color(0xff009F65),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(color: Color(0xff777777), fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _TopicProgress extends StatelessWidget {
  final String title;
  final double percent;

  const _TopicProgress({required this.title, required this.percent});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            Text(
              "${(percent * 100).toInt()}%",
              style: const TextStyle(
                color: Color(0xff009F65),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: LinearProgressIndicator(
            value: percent,
            minHeight: 8,
            backgroundColor: const Color(0xffECECEC),
            valueColor: const AlwaysStoppedAnimation(Color(0xff22CC7A)),
          ),
        ),
      ],
    );
  }
}

class _WordChip extends StatelessWidget {
  final String text;

  const _WordChip(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xffE9FAF2),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xff009F65),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class RecommendationBox extends StatelessWidget {
  const RecommendationBox({super.key});

  @override
  Widget build(BuildContext context) {
    final questions = [
      "어릴 적 가장 행복했던 순간은 언제였어요?",
      "아버지를 처음 만났을 때 기분이 어떠셨어요?",
      "가장 기억에 남는 여행은 어디였나요?",
      "요즘 가장 많이 생각나는 추억은 무엇인가요?",
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xffFFF8E7),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.lightbulb_outline, color: Color(0xffF9A825)),
              SizedBox(width: 8),
              Text(
                "추천 질문",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
              ),
            ],
          ),
          const SizedBox(height: 18),
          ...questions.map(
            (q) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.chat_bubble_outline,
                      size: 18,
                      color: Color(0xff22CC7A),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(q, style: const TextStyle(fontSize: 14)),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: Color(0xffAAAAAA),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
