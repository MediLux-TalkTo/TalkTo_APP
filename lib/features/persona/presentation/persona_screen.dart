import 'package:flutter/material.dart';

import '../../../shared/widgets/bottom_nav_bar.dart';
import 'widgets/persona_card.dart';

class PersonaScreen extends StatefulWidget {
  const PersonaScreen({super.key});

  @override
  State<PersonaScreen> createState() => _PersonaScreenState();
}

class _PersonaScreenState extends State<PersonaScreen> {
  int _selectedIndex = 0;

  final List<_PersonaTabData> _tabs = const [
    _PersonaTabData(label: '어머니'),
    _PersonaTabData(label: '아버지'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFCF8),
      body: SafeArea(
        child: Stack(
          children: [
            const _SoftBackgroundDecorations(),
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(26, 48, 26, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _PremiumBadge(),
                        const SizedBox(height: 4),
                        const Text(
                          'VOICE PERSONA',
                          style: TextStyle(
                            color: Color(0xFF009F65),
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 3,
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          '남겨주신 목소리로\n다시 이야기 나눠요',
                          style: TextStyle(
                            color: Color(0xFF222222),
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                            height: 1.35,
                          ),
                        ),
                        const SizedBox(height: 26),
                        _PersonaTabs(
                          tabs: _tabs,
                          selectedIndex: _selectedIndex,
                          onChanged: (index) {
                            setState(() {
                              _selectedIndex = index;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        PersonaCard(
                          name: _tabs[_selectedIndex].label,
                          imageUrl: _selectedIndex == 0
                              ? 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200'
                              : 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200',
                          learningText: _selectedIndex == 0
                              ? '말투 학습 87% · 녹음 12개'
                              : '말투 학습 64% · 녹음 8개',
                        ),
                      ],
                    ),
                  ),
                ),
                const BottomNavBar(currentTab: BottomNavTab.persona),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PersonaTabData {
  final String label;

  const _PersonaTabData({required this.label});
}

class _PremiumBadge extends StatelessWidget {
  const _PremiumBadge();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: const Color(0xFFFFE3AE),
          borderRadius: BorderRadius.circular(100),
        ),
        child: const Text(
          'PREMIUM',
          style: TextStyle(
            color: Color(0xFFFF9F1C),
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _PersonaTabs extends StatelessWidget {
  final List<_PersonaTabData> tabs;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const _PersonaTabs({
    required this.tabs,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(tabs.length, (index) {
        final selected = selectedIndex == index;

        return Padding(
          padding: EdgeInsets.only(right: index == tabs.length - 1 ? 0 : 8),
          child: GestureDetector(
            onTap: () => onChanged(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              height: 38,
              padding: const EdgeInsets.symmetric(horizontal: 22),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected ? const Color(0xFF22CC7A) : Colors.white,
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                  color: selected
                      ? const Color(0xFF22CC7A)
                      : const Color(0xFFE7E2DA),
                ),
              ),
              child: Text(
                tabs[index].label,
                style: TextStyle(
                  color: selected ? Colors.white : const Color(0xFF9A9A9A),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _SoftBackgroundDecorations extends StatelessWidget {
  const _SoftBackgroundDecorations();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          right: 30,
          top: 74,
          child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3C7).withOpacity(0.65),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          right: 18,
          top: 170,
          child: Transform.rotate(
            angle: -0.5,
            child: Icon(
              Icons.eco_outlined,
              size: 54,
              color: const Color(0xFFB6EFA5).withOpacity(0.42),
            ),
          ),
        ),
        Positioned(
          right: 82,
          top: 185,
          child: Transform.rotate(
            angle: -0.18,
            child: Icon(
              Icons.local_florist_outlined,
              size: 150,
              color: const Color(0xFFFFCFCF).withOpacity(0.27),
            ),
          ),
        ),
        Positioned(
          right: 42,
          top: 285,
          child: Transform.rotate(
            angle: 0.3,
            child: Icon(
              Icons.auto_awesome,
              size: 26,
              color: const Color(0xFFFFD7A8).withOpacity(0.65),
            ),
          ),
        ),
        Positioned(
          right: 174,
          top: 220,
          child: Transform.rotate(
            angle: -0.3,
            child: Icon(
              Icons.auto_awesome,
              size: 28,
              color: const Color(0xFFD6D2FF).withOpacity(0.75),
            ),
          ),
        ),
      ],
    );
  }
}
