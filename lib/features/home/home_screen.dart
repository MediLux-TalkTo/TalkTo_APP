import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../shared/widgets/bottom_nav_bar.dart';
import '../onboarding/profile_setup_screen.dart';
import '../question/question_screen.dart';

class HomeScreen extends StatefulWidget {
  final List<ProfileData> profiles;

  const HomeScreen({super.key, required this.profiles});

  static const Color primary = Color(0xFF22CC7A);
  static const Color subText = Color(0xFF7C8273);
  static const Color darkText = Color(0xFF222222);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedProfileIndex = 0;

  ProfileData get selectedProfile => widget.profiles[_selectedProfileIndex];

  @override
  Widget build(BuildContext context) {
    final selectedName = selectedProfile.name;

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
                        Text(
                          '$selectedName 의 어떤 이야기를\n들어볼까요?',
                          style: const TextStyle(
                            fontSize: 22,
                            height: 1.35,
                            fontWeight: FontWeight.w700,
                            color: HomeScreen.darkText,
                          ),
                        ),
                        const SizedBox(height: 22),
                        _ProfileSelector(
                          profiles: widget.profiles,
                          selectedIndex: _selectedProfileIndex,
                          onSelected: (index) {
                            setState(() {
                              _selectedProfileIndex = index;
                            });
                          },
                        ),
                        const SizedBox(height: 18),
                        _VoiceProgressCard(
                          name: selectedName,
                          recordingCount: 5,
                        ),
                        const SizedBox(height: 14),
                        _UploadButton(name: selectedName),
                        const SizedBox(height: 18),
                        _QuestionCard(name: selectedName),
                      ],
                    ),
                  ),
                ),
                BottomNavBar(
                  currentTab: BottomNavTab.home,
                  profiles: widget.profiles,
                ),
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
  final List<ProfileData> profiles;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const _ProfileSelector({
    required this.profiles,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ...List.generate(profiles.length, (index) {
          final profile = profiles[index];

          return Padding(
            padding: const EdgeInsets.only(right: 18),
            child: GestureDetector(
              onTap: () => onSelected(index),
              child: _ProfileAvatar(
                name: profile.name,
                selected: selectedIndex == index,
                imageUrl: _profileImageUrl(profile.name),
              ),
            ),
          );
        }),
        const _AddProfileButton(),
      ],
    );
  }

  String _profileImageUrl(String name) {
    if (name.contains('아버지') || name.contains('할아버지')) {
      return 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200';
    }

    return 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200';
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
  final String name;
  final int recordingCount;

  const _VoiceProgressCard({required this.name, required this.recordingCount});

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
              _CircularProgressBadge(
                currentCount: recordingCount,
                targetCount: 20,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$name의 목소리',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: HomeScreen.darkText,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${20 - recordingCount}개 더 모으면 페르소나 완성',
                      style: const TextStyle(
                        fontSize: 12,
                        color: HomeScreen.subText,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE3AE),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: const Text(
                  'PREMIUM',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFFF9F1C),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F8EF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFA982),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '최근 통화 · 6일 전',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF009F65),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextSpan(
                              text: ' · 12:34',
                              style: TextStyle(
                                fontSize: 13,
                                color: HomeScreen.subText,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$name의 어린 시절 이야기',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: HomeScreen.darkText,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  size: 26,
                  color: Color(0xFF7C8273),
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
  final int currentCount;
  final int targetCount;

  const _CircularProgressBadge({
    required this.currentCount,
    this.targetCount = 20,
  });

  @override
  Widget build(BuildContext context) {
    final progress = targetCount == 0
        ? 0.0
        : (currentCount / targetCount).clamp(0.0, 1.0);

    return SizedBox(
      width: 70,
      height: 70,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 66,
            height: 66,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 5,
              strokeCap: StrokeCap.round,
              backgroundColor: const Color(0xFFEFE7DC),
              valueColor: const AlwaysStoppedAnimation(HomeScreen.primary),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$currentCount',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 25,
                  height: 1.0,
                  fontWeight: FontWeight.w500,
                  color: HomeScreen.darkText,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                '/ $targetCount',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  height: 1.0,
                  fontWeight: FontWeight.w400,
                  color: HomeScreen.subText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _UploadButton extends StatelessWidget {
  final String name;

  const _UploadButton({required this.name});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.upload_rounded, size: 19),
        label: Text(
          '$name 통화 녹음 올리기',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
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
  final String name;

  const _QuestionCard({required this.name});

  @override
  Widget build(BuildContext context) {
    final questions = [
      ('결혼 전, $name의 스무 살은 어땠어요?', '젊은 시절 · 목소리 담기', true),
      ('저를 키우며 가장 뿌듯했던 순간은요?', '나를 키우며 · 목소리 담기', true),
      ('요즘 $name의 하루는 어떻게 흘러가요?', '지금 · 목소리 담기', true),
      ('$name는 어릴 적 어떤 아이였나요?', '녹음 완료 · 다시 듣기', false),
      ('$name의 손맛, 그 비법을 들려주세요', '녹음 완료 · 다시 듣기', false),
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
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => QuestionScreen(
                          profileName: name,
                          question: item.$1,
                        ),
                      ),
                    );
                  },
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
  final VoidCallback? onTap;

  const _QuestionTile({
    required this.title,
    required this.subtitle,
    required this.active,
    required this.showDivider,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: active ? onTap : null,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: active
                        ? HomeScreen.primary
                        : const Color(0xFFEFECE6),
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
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF009F65),
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
      ),
    );
  }
}
