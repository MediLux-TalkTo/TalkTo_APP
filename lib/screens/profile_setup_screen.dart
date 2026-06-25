import 'package:flutter/material.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _profiles = [];

  bool get _canContinue => _profiles.isNotEmpty;

  void _addProfile(String name) {
    final value = name.trim();
    if (value.isEmpty) return;

    setState(() {
      _profiles.add(value);
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 38, 28, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
              ),
              const SizedBox(height: 28),
              const Center(child: _StepIndicator(currentIndex: 1)),
              const SizedBox(height: 52),
              const Text(
                '누구의 목소리를\n담아볼까요?',
                style: TextStyle(
                  fontSize: 26,
                  height: 1.3,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF222222),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                '한 분씩 더하고, 지금 어떤 사이인지 알려주세요.\n맞춤 홈 화면을 준비해 드려요.',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.7,
                  color: Color(0xFF8A8A8A),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: '호칭을 입력하세요 (예: 외할머니, 큰형)',
                        hintStyle: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFFB0B0B0),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 15,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: Color(0xFFE1E1E1),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: Color(0xFF20D080),
                          ),
                        ),
                      ),
                      onSubmitted: _addProfile,
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () => _addProfile(_controller.text),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD9D9D9),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text('추가'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _PresetChip(label: '어머니', onTap: () => _addProfile('어머니')),
                  _PresetChip(label: '아버지', onTap: () => _addProfile('아버지')),
                  _PresetChip(label: '할머니', onTap: () => _addProfile('할머니')),
                  _PresetChip(label: '할아버지', onTap: () => _addProfile('할아버지')),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                height: 84,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: const Color(0xFFE0E0E0),
                    style: BorderStyle.solid,
                  ),
                ),
                child: Text(
                  _profiles.isEmpty ? '프로필을 추가해주세요' : _profiles.join(', '),
                  style: TextStyle(
                    fontSize: 14,
                    color: _profiles.isEmpty
                        ? const Color(0xFF999999)
                        : const Color(0xFF222222),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _canContinue ? () {} : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF20D080),
                    disabledBackgroundColor: const Color(0xFFD9D9D9),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    '계속하기',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
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

class _PresetChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _PresetChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      onPressed: onTap,
      backgroundColor: const Color(0xFFFFF9F6),
      side: BorderSide.none,
      label: Text(
        '+  $label',
        style: const TextStyle(
          color: Color(0xFF8A7468),
          fontWeight: FontWeight.w600,
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
