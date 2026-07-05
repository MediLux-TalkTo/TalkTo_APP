import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'profile_setup_screen.dart';

class OnboardingIntroScreen extends StatelessWidget {
  const OnboardingIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(26, 28.9, 26, 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(child: _StepIndicator(currentIndex: 0)),
              const SizedBox(height: 29),
              const Text(
                '일상의 통화를\n오래도록 곁에 두세요',
                style: TextStyle(
                  fontSize: 24,
                  height: 1.3,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF222222),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'TalkTo는 부모님과의 통화를 기록으로 남기고, 그 목소리를\n닮은 AI와 이야기 나눌 수 있게 도와드려요.',
                style: TextStyle(
                  fontSize: 14.5,
                  height: 1.7,
                  color: Color(0xFF8A8A8A),
                ),
              ),
              const SizedBox(height: 70),
              const _FeatureItem(
                assetPath: 'assets/icons/upload_icon.svg',
                title: '통화 녹음을 올려요',
                description: '부모님과의 통화를 그대로 담기만 하면 돼요.',
              ),
              const SizedBox(height: 22),
              const _FeatureItem(
                assetPath: 'assets/icons/stack_icon.svg',
                title: '목소리가 차곡차곡 쌓여요',
                description: '흩어진 통화가 한 분 한 분의 보관함이 돼요.',
              ),
              const SizedBox(height: 22),
              const _FeatureItem(
                assetPath: 'assets/icons/twinkle_icon.svg',
                title: '목소리가 한 사람이 돼요',
                description: '쌓인 통화로 그분의 말투를 닮은 AI와 대화할 수 있어요.',
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ProfileSetupScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF20D080),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    '다음',
                    style: TextStyle(
                      fontSize: 15.5,
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

class _FeatureItem extends StatelessWidget {
  final String assetPath;
  final String title;
  final String description;

  const _FeatureItem({
    required this.assetPath,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: const Color(0xFFEAF8F1),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Center(
            child: SvgPicture.asset(assetPath, width: 21, height: 21),
          ),
        ),

        const SizedBox(width: 18),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF222222),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    height: 1.3,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  description,
                  style: const TextStyle(
                    color: Color(0xFF7C8273),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
