import 'package:flutter/material.dart';

import '../../core/state/app_state.dart';
import '../../features/archive/archive_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/persona/presentation/persona_screen.dart';

enum BottomNavTab { home, archive, persona, my }

class BottomNavBar extends StatelessWidget {
  final BottomNavTab currentTab;

  const BottomNavBar({super.key, required this.currentTab});

  static const Color primary = Color(0xFF22CC7A);
  static const Color inactive = Color(0xFFD3D3D3);

  void _goToRoot(BuildContext context, Widget screen) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => screen),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final profiles = AppState.safeProfiles;

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
          _BottomNavItem(
            icon: Icons.home_outlined,
            label: '홈',
            selected: currentTab == BottomNavTab.home,
            onTap: () {
              _goToRoot(context, const HomeScreen());
            },
          ),
          _BottomNavItem(
            icon: Icons.inventory_2_outlined,
            label: '기록',
            selected: currentTab == BottomNavTab.archive,
            onTap: () {
              _goToRoot(context, const ArchiveScreen());
            },
          ),
          _BottomNavItem(
            icon: Icons.chat_bubble_outline_rounded,
            label: 'AI',
            selected: currentTab == BottomNavTab.persona,
            onTap: () {
              _goToRoot(context, const PersonaScreen());
            },
          ),
          _BottomNavItem(
            icon: Icons.person_outline_rounded,
            label: '마이',
            selected: currentTab == BottomNavTab.my,
            onTap: () {
              // TODO: MyPage 초기 화면 연결
            },
          ),
        ],
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _BottomNavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? BottomNavBar.primary : BottomNavBar.inactive;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        width: 64,
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
      ),
    );
  }
}
