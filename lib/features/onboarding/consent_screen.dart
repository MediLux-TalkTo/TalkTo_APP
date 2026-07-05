import 'package:flutter/material.dart';

import '../home/home_screen.dart';

class ConsentScreen extends StatefulWidget {
  const ConsentScreen({super.key});

  @override
  State<ConsentScreen> createState() => _ConsentScreenState();
}

class _ConsentScreenState extends State<ConsentScreen> {
  bool privacy = false;
  bool voice = false;
  bool aiTraining = false;
  bool overseas = false;
  bool postAi = false;

  bool get allChecked => privacy && voice && aiTraining && overseas && postAi;
  bool get canContinue => privacy && voice;

  void _toggleAll() {
    final next = !allChecked;

    setState(() {
      privacy = next;
      voice = next;
      aiTraining = next;
      overseas = next;
      postAi = next;
    });
  }

  void _update({
    bool? privacy,
    bool? voice,
    bool? aiTraining,
    bool? overseas,
    bool? postAi,
  }) {
    setState(() {
      if (privacy != null) this.privacy = privacy;
      if (voice != null) this.voice = voice;
      if (aiTraining != null) this.aiTraining = aiTraining;
      if (overseas != null) this.overseas = overseas;
      if (postAi != null) this.postAi = postAi;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(26, 28.9, 26, 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 20,
                        color: Color(0xFF222222),
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ),
                  const _StepIndicator(currentIndex: 2),
                ],
              ),
              const SizedBox(height: 52),
              const Text(
                '시작하기 전에\n몇 가지만 확인할게요',
                style: TextStyle(
                  fontSize: 26,
                  height: 1.3,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF222222),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                '모든 녹음은 회원님의 것이에요.\n동의는 설정에서 언제든 바꿀 수 있어요.',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.7,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF7C8273),
                ),
              ),
              const SizedBox(height: 20),
              _AllAgreeButton(checked: allChecked, onTap: _toggleAll),
              const SizedBox(height: 20),
              _ConsentItem(
                checked: privacy,
                icon: Icons.shield_outlined,
                title: '[필수] 개인정보 수집·이용',
                description: '계정 및 서비스 제공',
                onTap: () => _update(privacy: !privacy),
              ),
              const SizedBox(height: 10),
              _ConsentItem(
                checked: voice,
                icon: Icons.mic_none_rounded,
                title: '[필수] 음성 파일 처리',
                description: '업로드 보관·분석',
                onTap: () => _update(voice: !voice),
              ),
              const SizedBox(height: 10),
              _ConsentItem(
                checked: aiTraining,
                icon: Icons.auto_awesome,
                title: '[선택] AI 학습 활용',
                description: '서비스 품질 향상',
                onTap: () => _update(aiTraining: !aiTraining),
              ),
              const SizedBox(height: 10),
              _ConsentItem(
                checked: overseas,
                icon: Icons.language,
                title: '[선택] 국외 이전',
                description: 'AI 처리 인프라',
                onTap: () => _update(overseas: !overseas),
              ),
              const SizedBox(height: 10),
              _ConsentItem(
                checked: postAi,
                icon: Icons.chat_bubble_outline_rounded,
                title: '[선택] 사후 AI 사용',
                description: 'Memories·Persona 활성화',
                onTap: () => _update(postAi: !postAi),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: canContinue
                      ? () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const HomeScreen(),
                            ),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF20D080),
                    disabledBackgroundColor: const Color(0xFFD9D9D9),
                    foregroundColor: Colors.white,
                    elevation: canContinue ? 8 : 0,
                    shadowColor: const Color(0xFF20D080).withOpacity(0.35),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    allChecked ? '동의하고 계속하기' : '다음',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
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

class _AllAgreeButton extends StatelessWidget {
  final bool checked;
  final VoidCallback onTap;

  const _AllAgreeButton({required this.checked, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        width: double.infinity,
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: checked ? const Color(0xFF7C8672) : const Color(0xFFD9DAD6),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Icon(
              Icons.check,
              size: 20,
              color: checked ? Colors.white : Colors.white.withOpacity(0.9),
            ),
            const SizedBox(width: 18),
            Text(
              '전체 동의하기',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: checked ? Colors.white : Colors.white.withOpacity(0.85),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConsentItem extends StatelessWidget {
  final bool checked;
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  const _ConsentItem({
    required this.checked,
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        width: double.infinity,
        height: 68,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: checked ? const Color(0xFF20D080) : const Color(0xFFF0E8DF),
            width: checked ? 1.4 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            _CheckBox(checked: checked),
            const SizedBox(width: 15),
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFFEAF8F1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 18, color: const Color(0xFF009F65)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: title.contains('[필수]')
                          ? const Color(0xFF009F65)
                          : const Color(0xFF555555),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF8A8A8A),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, size: 22, color: Color(0xFFE0E0E0)),
          ],
        ),
      ),
    );
  }
}

class _CheckBox extends StatelessWidget {
  final bool checked;

  const _CheckBox({required this.checked});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: checked ? const Color(0xFF20D080) : Colors.white,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: checked ? const Color(0xFF20D080) : const Color(0xFFE1E1E1),
          width: 1.2,
        ),
      ),
      child: checked
          ? const Icon(Icons.check, size: 22, color: Colors.white)
          : null,
    );
  }
}

class _StepIndicator extends StatelessWidget {
  final int currentIndex;

  const _StepIndicator({required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        final selected = index == currentIndex;

        return Container(
          width: selected ? 24 : 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF20D080) : const Color(0xFFD9D9D9),
            borderRadius: BorderRadius.circular(100),
          ),
        );
      }),
    );
  }
}
