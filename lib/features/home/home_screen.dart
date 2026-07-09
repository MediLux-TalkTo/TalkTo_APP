import 'package:file_picker/file_picker.dart' as fp;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../shared/widgets/bottom_nav_bar.dart';
import '../onboarding/data/consent_api.dart';
import '../question/question_screen.dart';
import '../recordings/data/recording_api.dart';
import '../recordings/services/recording_upload_service.dart';
import 'data/subject_api.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const Color primary = Color(0xFF22CC7A);
  static const Color subText = Color(0xFF7C8273);
  static const Color darkText = Color(0xFF222222);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ConsentApi _consentApi = ConsentApi();
  final SubjectApi _subjectApi = SubjectApi();
  final RecordingApi _recordingApi = RecordingApi();
  final RecordingUploadService _uploadService = RecordingUploadService();

  bool _isUploading = false;

  List<Subject> _subjects = [];
  bool _isLoading = true;
  String? _errorMessage;
  int _selectedProfileIndex = 0;

  List<Recording> _recordings = [];

  int get recordingCount => _recordings.length;

  Subject get selectedSubject => _subjects[_selectedProfileIndex];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      final subjects = await _subjectApi.getSubjects();

      if (!mounted) return;

      setState(() {
        _subjects = subjects;
        _selectedProfileIndex = 0;
        _isLoading = false;
      });

      if (subjects.isNotEmpty) {
        await _loadRecordings(subjects.first.id);
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorMessage = '대상자를 불러오지 못했습니다.';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadSubjects() async {
    try {
      final subjects = await _subjectApi.getSubjects();

      setState(() {
        _subjects = subjects;
        _selectedProfileIndex = 0;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = '대상자를 불러오지 못했습니다.';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadRecordings(String subjectId) async {
    final recordings = await _recordingApi.getRecordings(subjectId);

    setState(() {
      _recordings = recordings;
    });
  }

  Future<void> _uploadRecording() async {
    try {
      final result = await fp.FilePicker.pickFiles(
        type: fp.FileType.audio,
        allowMultiple: false,
        withData: true,
      );

      if (result == null) return;

      final file = result.files.first;

      final mimeType = _uploadService.detectMimeType(file);

      setState(() {
        _isUploading = true;
      });

      await _consentApi.acceptUploadConsents(subjectId: selectedSubject.id);

      final uploadIntent = await _recordingApi.createUploadIntent(
        subjectId: selectedSubject.id,
        originalFilename: file.name,
        mimeType: mimeType,
        fileSizeBytes: file.size,
        durationSeconds: null,
        memo: '',
        conversationPartnerName: '',
        relatedQuestionId: '',
        relatedQuestionText: '',
        fileHash: '',
        source: 'app_recording',
        platform: _uploadService.getPlatformName(),
        singleFile: true,
      );

      await _uploadService.uploadToPresignedUrl(
        uploadUrl: uploadIntent.uploadUrl,
        file: file,
        mimeType: mimeType,
      );

      await _recordingApi.completeUpload(
        recordingId: uploadIntent.recording.id,
        uploadIntentId: uploadIntent.uploadIntentId,
      );

      await _loadRecordings(selectedSubject.id);

      await _loadSubjects();

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('업로드가 완료되었습니다.')));
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('업로드 실패\n$e')));
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_errorMessage != null) {
      return Scaffold(body: Center(child: Text(_errorMessage!)));
    }

    if (_subjects.isEmpty) {
      return const Scaffold(body: Center(child: Text('등록된 대상자가 없습니다.')));
    }

    final currentSubject = selectedSubject;
    final selectedName = selectedSubject.displayName;
    final isAlive = selectedSubject.isAlive;

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
                          subjects: _subjects,
                          selectedIndex: _selectedProfileIndex,
                          onSelected: (index) async {
                            setState(() {
                              _selectedProfileIndex = index;
                              _recordings = [];
                            });

                            await _loadRecordings(_subjects[index].id);
                          },
                        ),
                        const SizedBox(height: 18),
                        _VoiceProgressCard(
                          name: selectedName,
                          recordingCount: recordingCount,
                          isAlive: isAlive,
                        ),
                        const SizedBox(height: 14),
                        _UploadButton(
                          name: selectedName,
                          enabled: !_isUploading,
                          onUpload: _uploadRecording,
                        ),
                        const SizedBox(height: 18),

                        if (isAlive)
                          _QuestionCard(name: selectedName)
                        else
                          _PassedAwayHomeSection(name: selectedName),
                      ],
                    ),
                  ),
                ),
                BottomNavBar(currentTab: BottomNavTab.home),
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
  final List<Subject> subjects;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const _ProfileSelector({
    required this.subjects,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ...List.generate(subjects.length, (index) {
          final subject = subjects[index];

          return Padding(
            padding: const EdgeInsets.only(right: 18),
            child: GestureDetector(
              onTap: () => onSelected(index),
              child: _ProfileAvatar(
                name: subject.displayName,
                selected: selectedIndex == index,
                imageUrl: _profileImageUrl(subject.displayName),
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
  final bool isAlive;

  const _VoiceProgressCard({
    required this.name,
    required this.recordingCount,
    required this.isAlive,
  });

  @override
  Widget build(BuildContext context) {
    final remainingCount = (20 - recordingCount).clamp(0, 20);

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
                      remainingCount == 0
                          ? '페르소나 완성 조건을 충족했어요'
                          : '$remainingCount개 더 모으면 페르소나 완성',
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
          _RecentRecordingBox(name: name, isAlive: isAlive),
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
  final VoidCallback onUpload;
  final bool enabled;

  const _UploadButton({
    required this.name,
    required this.onUpload,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: enabled ? onUpload : null,
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

class _PassedAwayHomeSection extends StatelessWidget {
  final String name;

  const _PassedAwayHomeSection({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 24),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFCF8),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFF1E7DA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '오늘 다시 들어보면\n좋은 $name의 목소리',
                style: const TextStyle(
                  fontSize: 18,
                  height: 1.4,
                  fontWeight: FontWeight.w700,
                  color: HomeScreen.darkText,
                ),
              ),
              const Spacer(),
              const Text(
                '↻ 다른 기억',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF009F65),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFF1E7DA)),
            ),
            child: Column(
              children: [
                _MemoryVoiceTile(
                  title: '2026. 10. 2. 녹음',
                  subtitle: '9일 전 담음 · 08:12',
                ),
                const Divider(height: 24, color: Color(0xFFF0E7DC)),
                _MemoryVoiceTile(
                  title: '2024. 03. 05. 녹음',
                  subtitle: '2일 전 담음 · 05:30',
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F8EF),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFCBEFDC)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: Color(0xFFD6F7E6),
                  child: Icon(
                    Icons.upload_rounded,
                    color: Color(0xFF009F65),
                    size: 22,
                  ),
                ),
                SizedBox(width: 14),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '아직 담지 못한 목소리가 있다면\n',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: HomeScreen.darkText,
                          ),
                        ),
                        TextSpan(
                          text:
                              '오래된 통화나 영상 어딘가 남아있을 목소리를 올려두면, 차곡차곡 모여 언젠가 Voice Persona로 다시 만날 수 있어요.',
                          style: TextStyle(
                            fontSize: 13,
                            height: 1.6,
                            color: HomeScreen.subText,
                          ),
                        ),
                      ],
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

class _MemoryVoiceTile extends StatelessWidget {
  final String title;
  final String subtitle;

  const _MemoryVoiceTile({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: const BoxDecoration(
            color: Color(0xFFFFA982),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.play_arrow_rounded,
            color: Colors.white,
            size: 28,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '$title\n',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: HomeScreen.darkText,
                  ),
                ),
                TextSpan(
                  text: subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: HomeScreen.subText,
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

class _RecentRecordingBox extends StatelessWidget {
  final String name;
  final bool isAlive;

  const _RecentRecordingBox({required this.name, required this.isAlive});

  @override
  Widget build(BuildContext context) {
    final label = isAlive ? '최근 통화' : '최근 업로드';
    final title = '$name의 어린 시절 이야기';

    return Container(
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
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '$label · 6일 전',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF009F65),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const TextSpan(
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
                  title,
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
    );
  }
}
