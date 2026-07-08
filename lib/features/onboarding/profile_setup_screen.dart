import 'package:flutter/material.dart';

import './data/subject_api.dart';
import 'consent_screen.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<ProfileData> _profiles = [];
  final SubjectApi _subjectApi = SubjectApi();

  bool _isSubmitting = false;

  bool get _canContinue => _profiles.isNotEmpty;

  void _addProfile(String name) {
    final value = name.trim();
    if (value.isEmpty) return;

    final alreadyExists = _profiles.any((profile) => profile.name == value);
    if (alreadyExists) {
      _controller.clear();
      return;
    }

    setState(() {
      _profiles.add(ProfileData(name: value));
      _controller.clear();
    });
  }

  String _toRelationship(String name) {
    if (name.contains('어머니')) return 'mother';
    if (name.contains('아버지')) return 'father';
    if (name.contains('할머니')) return 'grandmother';
    if (name.contains('할아버지')) return 'grandfather';
    return 'family';
  }

  Future<void> _submitSubjects() async {
    if (_profiles.isEmpty || _isSubmitting) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      for (final profile in _profiles) {
        await _subjectApi.createSubject(
          displayName: profile.name,
          relationship: _toRelationship(profile.name),
          lifeStatus: _toLifeStatus(profile.status),
        );
      }

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ConsentScreen(profiles: _profiles)),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('프로필 저장에 실패했습니다. $e')));
    } finally {
      if (!mounted) return;

      setState(() {
        _isSubmitting = false;
      });
    }
  }

  String _toLifeStatus(ProfileStatus status) {
    return status == ProfileStatus.alive ? 'LIVING' : 'DECEASED';
  }

  void _removeProfile(ProfileData profile) {
    setState(() {
      _profiles.remove(profile);
    });
  }

  void _toggleStatus(ProfileData profile, ProfileStatus status) {
    setState(() {
      final index = _profiles.indexOf(profile);
      if (index == -1) return;

      _profiles[index] = profile.copyWith(status: status);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
                  const _StepIndicator(currentIndex: 1),
                ],
              ),

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
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF7C8273),
                ),
              ),

              const SizedBox(height: 30),

              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: TextField(
                        controller: _controller,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF222222),
                        ),
                        decoration: InputDecoration(
                          hintText: '호칭을 입력하세요 (예: 외할머니, 큰형)',
                          hintStyle: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFFC9C9C9),
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
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 66,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () => _addProfile(_controller.text),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _controller.text.trim().isEmpty
                            ? const Color(0xFFD9D9D9)
                            : const Color(0xFF7C8672),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        '추가',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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

              const SizedBox(height: 28),

              Expanded(
                child: _profiles.isEmpty
                    ? const Align(
                        alignment: Alignment.topCenter,
                        child: _EmptyProfileBox(),
                      )
                    : ListView.separated(
                        padding: EdgeInsets.zero,
                        itemCount: _profiles.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final profile = _profiles[index];

                          return _ProfileCard(
                            profile: profile,
                            onDelete: () => _removeProfile(profile),
                            onStatusChanged: (status) {
                              _toggleStatus(profile, status);
                            },
                          );
                        },
                      ),
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _canContinue && !_isSubmitting
                      ? _submitSubjects
                      : null,
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

class ProfileData {
  final String name;
  final ProfileStatus status;

  const ProfileData({required this.name, this.status = ProfileStatus.alive});

  ProfileData copyWith({String? name, ProfileStatus? status}) {
    return ProfileData(name: name ?? this.name, status: status ?? this.status);
  }
}

enum ProfileStatus { alive, passed }

class _ProfileCard extends StatelessWidget {
  final ProfileData profile;
  final VoidCallback onDelete;
  final ValueChanged<ProfileStatus> onStatusChanged;

  const _ProfileCard({
    required this.profile,
    required this.onDelete,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isAlive = profile.status == ProfileStatus.alive;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFF20D080), width: 1.2),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundColor: Color(0xFFEDEDED),
                child: Icon(Icons.person, color: Color(0xFF999999)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  profile.name,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF222222),
                  ),
                ),
              ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFE1E1E1)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  onPressed: onDelete,
                  icon: const Icon(
                    Icons.delete_outline,
                    size: 15,
                    color: Color(0xFF999999),
                  ),
                  padding: EdgeInsets.zero,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Container(
            height: 48,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0F0),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _StatusButton(
                    label: '지금 함께 계세요',
                    selected: isAlive,
                    onTap: () => onStatusChanged(ProfileStatus.alive),
                  ),
                ),
                Expanded(
                  child: _StatusButton(
                    label: '곁을 떠나셨어요',
                    selected: !isAlive,
                    onTap: () => onStatusChanged(ProfileStatus.passed),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F8EF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.phone_outlined, size: 13, color: Color(0xFF009F65)),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '맞춤 질문을 추천해 통화를 녹음하도록 도와드려요',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF009F65),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _StatusButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(11),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: selected ? const Color(0xFF009F65) : const Color(0xFF999999),
          ),
        ),
      ),
    );
  }
}

class _EmptyProfileBox extends StatelessWidget {
  const _EmptyProfileBox();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedBorderPainter(),
      child: Container(
        width: double.infinity,
        height: 75,
        alignment: Alignment.center,
        child: const Text(
          '프로필을 추가해주세요',
          style: TextStyle(
            fontSize: 13,
            color: Color(0xFF999999),
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const radius = 18.0;
    const dashWidth = 5.0;
    const dashGap = 4.0;

    final paint = Paint()
      ..color = const Color(0xFFDADADA)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final rect = RRect.fromRectAndRadius(
      Offset.zero & size,
      const Radius.circular(radius),
    );

    final path = Path()..addRRect(rect);
    final metrics = path.computeMetrics();

    for (final metric in metrics) {
      double distance = 0;

      while (distance < metric.length) {
        final nextDistance = distance + dashWidth;
        canvas.drawPath(metric.extractPath(distance, nextDistance), paint);
        distance += dashWidth + dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      label: Text(
        '+  $label',
        style: const TextStyle(
          color: Color(0xFF7C8273),
          fontSize: 14,
          fontWeight: FontWeight.w500,
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
