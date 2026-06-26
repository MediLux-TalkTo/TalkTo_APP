import 'package:flutter/material.dart';

import 'recording_detail_screen.dart';

class ArchiveScreen extends StatelessWidget {
  const ArchiveScreen({super.key});

  static const Color primary = Color(0xFF22CC7A);
  static const Color subText = Color(0xFF7C8273);
  static const Color darkText = Color(0xFF222222);

  @override
  Widget build(BuildContext context) {
    final records = [
      RecordingItem(
        title: '아버지와 저녁 통화',
        person: '아버지',
        date: '6월 12일',
        duration: '05:30',
        tag: '# 일상',
      ),
      RecordingItem(
        title: '어머니의 어린 시절 이야기',
        person: '어머니',
        date: '6월 8일',
        duration: '12:34',
        tag: '# 어린 시절',
      ),
      RecordingItem(
        title: '아버지의 청춘 이야기',
        person: '아버지',
        date: '6월 5일',
        duration: '08:12',
        tag: '# 청춘',
      ),
      RecordingItem(
        title: '주말 안부 통화',
        person: '어머니',
        date: '6월 1일',
        duration: '21:08',
        tag: '# 안부',
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFFFCF8),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 42, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '보관함',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: darkText,
                      ),
                    ),
                    const SizedBox(height: 22),
                    const _LockedSearchBox(),
                    const SizedBox(height: 14),
                    const _AiSearchBox(),
                    const SizedBox(height: 20),
                    const _FilterChips(),
                    const SizedBox(height: 26),
                    const _MonthSelector(),
                    const SizedBox(height: 24),
                    ...records.map(
                      (record) => Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: _RecordingTile(
                          record: record,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    RecordingDetailScreen(record: record),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const _ArchiveBottomNavBar(),
          ],
        ),
      ),
    );
  }
}

class RecordingItem {
  final String title;
  final String person;
  final String date;
  final String duration;
  final String tag;

  const RecordingItem({
    required this.title,
    required this.person,
    required this.date,
    required this.duration,
    required this.tag,
  });
}

class _LockedSearchBox extends StatelessWidget {
  const _LockedSearchBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F4),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Row(
        children: [
          Icon(Icons.lock_outline_rounded, size: 18, color: Color(0xFFB1B5AA)),
          SizedBox(width: 14),
          Expanded(
            child: Text(
              '프리미엄 플랜으로 내용 검색 기능을 사용해보세요',
              style: TextStyle(fontSize: 14, color: Color(0xFFB1B5AA)),
            ),
          ),
        ],
      ),
    );
  }
}

class _AiSearchBox extends StatelessWidget {
  const _AiSearchBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3D9),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFFFDFA3)),
      ),
      child: const Row(
        children: [
          CircleAvatar(
            radius: 21,
            backgroundColor: Color(0xFFFFC85C),
            child: Icon(
              Icons.workspace_premium_outlined,
              color: Colors.white,
              size: 22,
            ),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'AI 통화 요약 + 대화 내용 검색\n',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF5C4630),
                    ),
                  ),
                  TextSpan(
                    text: '녹음 속 말씀까지 찾아드려요',
                    style: TextStyle(fontSize: 12, color: Color(0xFF9A7A45)),
                  ),
                ],
              ),
            ),
          ),
          Icon(Icons.lock_outline_rounded, size: 18, color: Color(0xFF8C7655)),
        ],
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  const _FilterChips();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        _FilterChip(label: '전체', selected: true),
        SizedBox(width: 10),
        _FilterChip(label: '어머니'),
        SizedBox(width: 10),
        _FilterChip(label: '아버지'),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;

  const _FilterChip({required this.label, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 22),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: selected ? ArchiveScreen.primary : Colors.white,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: selected ? ArchiveScreen.primary : const Color(0xFFE1E1E1),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: selected ? Colors.white : const Color(0xFF9A9A9A),
        ),
      ),
    );
  }
}

class _MonthSelector extends StatelessWidget {
  const _MonthSelector();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _SquareIconButton(icon: Icons.chevron_left_rounded, onTap: () {}),
        const Expanded(
          child: Column(
            children: [
              Text(
                '2026년 6월',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: ArchiveScreen.darkText,
                ),
              ),
              SizedBox(height: 4),
              Text(
                '녹음 4개',
                style: TextStyle(fontSize: 12, color: ArchiveScreen.subText),
              ),
            ],
          ),
        ),
        _SquareIconButton(icon: Icons.calendar_today_outlined, onTap: () {}),
      ],
    );
  }
}

class _SquareIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _SquareIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE9E3DA)),
      ),
      child: Icon(icon, size: 24, color: const Color(0xFF222222)),
    );
  }
}

class _RecordingTile extends StatelessWidget {
  final RecordingItem record;
  final VoidCallback onTap;

  const _RecordingTile({required this.record, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 88,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFEAF8F1)),
        ),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 17,
              backgroundColor: Color(0xFFFFA982),
              child: Icon(Icons.play_arrow_rounded, color: Colors.white),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '${record.title}\n',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: ArchiveScreen.darkText,
                      ),
                    ),
                    TextSpan(
                      text:
                          '${record.person} · ${record.date} · ${record.duration}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: ArchiveScreen.subText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Color(0xFFE0E0E0)),
          ],
        ),
      ),
    );
  }
}

class _ArchiveBottomNavBar extends StatelessWidget {
  const _ArchiveBottomNavBar();

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
        children: const [
          _NavItem(icon: Icons.home_outlined, label: '홈'),
          _NavItem(
            icon: Icons.inventory_2_outlined,
            label: '기록',
            selected: true,
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

  const _NavItem({
    required this.icon,
    required this.label,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? ArchiveScreen.primary : const Color(0xFFD3D3D3);

    return Column(
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
    );
  }
}
