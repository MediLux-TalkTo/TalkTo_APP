import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../archive/archive_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const Color primary = Color(0xFF22CC7A);
  static const Color subText = Color(0xFF7C8273);
  static const Color darkText = Color(0xFF222222);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FFF5),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              right: 0,
              top: 72,
              child: Opacity(
                opacity: 0.55,
                child: Icon(
                  Icons.mail_outline_rounded,
                  size: 160,
                  color: const Color(0xFFE8E5D9),
                ),
              ),
            ),
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _TopHeader(),
                        const SizedBox(height: 24),
                        const Text(
                          '어머니의 어떤 이야기를\n들어볼까요?',
                          style: TextStyle(
                            fontSize: 22,
                            height: 1.35,
                            fontWeight: FontWeight.w700,
                            color: darkText,
                          ),
                        ),
                        const SizedBox(height: 22),
                        const _ProfileSelector(),
                        const SizedBox(height: 18),
                        const _VoiceProgressCard(),
                        const SizedBox(height: 14),
                        const _UploadButton(),
                        const SizedBox(height: 18),
                        const _QuestionCard(),
                      ],
                    ),
                  ),
                ),
                const _BottomNavBar(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TopHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset('assets/images/talkto_logo.svg', width: 72),
        const Spacer(),
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Color(0xFFE5E5E5)),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.notifications_none_rounded,
            size: 21,
            color: Color(0xFF6F7768),
          ),
        ),
      ],
    );
  }
}

class _ProfileSelector extends StatelessWidget {
  const _ProfileSelector();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        _ProfileAvatar(
          name: '어머니',
          selected: true,
          imageUrl:
              'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200',
        ),
        SizedBox(width: 18),
        _ProfileAvatar(
          name: '아버지',
          selected: false,
          imageUrl:
              'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200',
        ),
        SizedBox(width: 18),
        _AddProfileButton(),
      ],
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  final String name;
  final bool selected;
  final String imageUrl;

  const _ProfileAvatar({
    required this.name,
    required this.selected,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 54,
          height: 54,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: selected ? HomeScreen.primary : Colors.transparent,
              width: 2,
            ),
          ),
          child: CircleAvatar(backgroundImage: NetworkImage(imageUrl)),
        ),
        const SizedBox(height: 7),
        Text(
          name,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: selected ? HomeScreen.primary : const Color(0xFF7C8273),
          ),
        ),
      ],
    );
  }
}

class _AddProfileButton extends StatelessWidget {
  const _AddProfileButton();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFF9CA395),
              width: 1.5,
              style: BorderStyle.solid,
            ),
          ),
          child: const Icon(Icons.add, color: Color(0xFF7C8273)),
        ),
        const SizedBox(height: 7),
        const Text(
          '추가',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF7C8273),
          ),
        ),
      ],
    );
  }
}

class _VoiceProgressCard extends StatelessWidget {
  const _VoiceProgressCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const _CircularProgressBadge(),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      '어머니의 목소리',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: HomeScreen.darkText,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '15개 더 모으면 페르소나 완성',
                      style: TextStyle(fontSize: 12, color: HomeScreen.subText),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3D9),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFFFDFA3)),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFC85C),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.chat_bubble_outline_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Voice Persona란?\n',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF5C4630),
                          ),
                        ),
                        TextSpan(
                          text: '목소리를 다 모으면 사용할 수 있어요',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF8C7655),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Icon(
                  Icons.lock_outline_rounded,
                  size: 16,
                  color: Color(0xFF8C7655),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CircularProgressBadge extends StatelessWidget {
  const _CircularProgressBadge();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64,
      height: 64,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: 0.25,
            strokeWidth: 5,
            backgroundColor: const Color(0xFFEFE7DC),
            valueColor: const AlwaysStoppedAnimation(HomeScreen.primary),
          ),
          const Text(
            '5\n/ 20',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              height: 1.0,
              fontWeight: FontWeight.w700,
              color: HomeScreen.darkText,
            ),
          ),
        ],
      ),
    );
  }
}

class _UploadButton extends StatelessWidget {
  const _UploadButton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.upload_rounded, size: 19),
        label: const Text(
          '어머니 통화 녹음 올리기',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: HomeScreen.primary,
          foregroundColor: Colors.white,
          elevation: 8,
          shadowColor: HomeScreen.primary.withOpacity(0.28),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
        ),
      ),
    );
  }
}

class _QuestionCard extends StatelessWidget {
  const _QuestionCard();

  @override
  Widget build(BuildContext context) {
    final questions = [
      ('결혼 전, 어머니의 스무 살은 어땠어요?', '젊은 시절 · 목소리 담기', true),
      ('저를 키우며 가장 뿌듯했던 순간은요?', '나를 키우며 · 목소리 담기', true),
      ('요즘 어머니의 하루는 어떻게 흘러가요?', '지금 · 목소리 담기', true),
      ('어머니는 어릴 적 어떤 아이였나요?', '녹음 완료 · 다시 듣기', false),
      ('어머니의 손맛, 그 비법을 들려주세요', '녹음 완료 · 다시 듣기', false),
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFCF8),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0xFFF1E7DA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Expanded(
                child: Text(
                  '어머니께 드리는\n이야기 질문',
                  style: TextStyle(
                    fontSize: 17,
                    height: 1.35,
                    fontWeight: FontWeight.w700,
                    color: HomeScreen.darkText,
                  ),
                ),
              ),
              Text(
                '매주 월요일',
                style: TextStyle(fontSize: 12, color: HomeScreen.subText),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFF1E7DA)),
            ),
            child: Column(
              children: List.generate(questions.length, (index) {
                final item = questions[index];

                return _QuestionTile(
                  title: item.$1,
                  subtitle: item.$2,
                  active: item.$3,
                  showDivider: index != questions.length - 1,
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuestionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool active;
  final bool showDivider;

  const _QuestionTile({
    required this.title,
    required this.subtitle,
    required this.active,
    required this.showDivider,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: active ? HomeScreen.primary : const Color(0xFFEFECE6),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  active ? Icons.add : Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: active ? 24 : 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 13.5,
                        height: 1.35,
                        fontWeight: FontWeight.w500,
                        color: active
                            ? HomeScreen.darkText
                            : const Color(0xFFAAA69E),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: active
                            ? const Color(0xFF009F65)
                            : const Color(0xFF009F65),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: 22,
                color: active
                    ? const Color(0xFF009F65)
                    : const Color(0xFFD8D4CE),
              ),
            ],
          ),
        ),
        if (showDivider)
          const Padding(
            padding: EdgeInsets.only(left: 68, right: 16),
            child: Divider(height: 1, color: Color(0xFFF0E7DC)),
          ),
      ],
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76,
      padding: const EdgeInsets.only(top: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEDE7DF))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(icon: Icons.home_outlined, label: '홈', selected: true),
          _NavItem(
            icon: Icons.inventory_2_outlined,
            label: '기록',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ArchiveScreen()),
              );
            },
          ),
          _NavItem(icon: Icons.chat_bubble_outline_rounded, label: 'AI'),
          _NavItem(icon: Icons.person_outline_rounded, label: '마이'),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? HomeScreen.primary : const Color(0xFFD3D3D3);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, size: 22, color: color),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
