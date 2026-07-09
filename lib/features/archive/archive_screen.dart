import 'package:flutter/material.dart';

import '../../shared/widgets/bottom_nav_bar.dart';
import '../home/data/subject_api.dart';
import '../recordings/data/recording_api.dart';
import 'recording_detail_screen.dart';

class ArchiveScreen extends StatefulWidget {
  const ArchiveScreen({super.key});

  static const Color primary = Color(0xFF22CC7A);
  static const Color subText = Color(0xFF7C8273);
  static const Color darkText = Color(0xFF222222);

  @override
  State<ArchiveScreen> createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends State<ArchiveScreen> {
  final SubjectApi _subjectApi = SubjectApi();
  final RecordingApi _recordingApi = RecordingApi();

  List<Subject> _subjects = [];
  List<Recording> _recordings = [];

  int _selectedSubjectIndex = 0;
  bool _isLoading = true;
  bool _isRecordingsLoading = false;
  String? _errorMessage;

  Subject get selectedSubject => _subjects[_selectedSubjectIndex];

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
        _selectedSubjectIndex = 0;
        _isLoading = false;
      });

      if (subjects.isNotEmpty) {
        await _loadRecordings(subjects.first.id);
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorMessage = '보관함을 불러오지 못했습니다.';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadRecordings(String subjectId) async {
    setState(() {
      _isRecordingsLoading = true;
    });

    try {
      final recordings = await _recordingApi.getRecordings(subjectId);

      if (!mounted) return;

      setState(() {
        _recordings = recordings;
        _isRecordingsLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _recordings = [];
        _isRecordingsLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFFFFCF8),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        backgroundColor: const Color(0xFFFFFCF8),
        body: Center(child: Text(_errorMessage!)),
        bottomNavigationBar: const BottomNavBar(
          currentTab: BottomNavTab.archive,
        ),
      );
    }

    if (_subjects.isEmpty) {
      return const Scaffold(
        backgroundColor: Color(0xFFFFFCF8),
        body: Center(child: Text('등록된 대상자가 없습니다.')),
        bottomNavigationBar: BottomNavBar(currentTab: BottomNavTab.archive),
      );
    }

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
                        color: ArchiveScreen.darkText,
                      ),
                    ),
                    const SizedBox(height: 22),
                    const _LockedSearchBox(),
                    const SizedBox(height: 14),
                    const _AiSearchBox(),
                    const SizedBox(height: 20),
                    _SubjectChips(
                      subjects: _subjects,
                      selectedIndex: _selectedSubjectIndex,
                      onSelected: (index) async {
                        setState(() {
                          _selectedSubjectIndex = index;
                          _recordings = [];
                        });

                        await _loadRecordings(_subjects[index].id);
                      },
                    ),
                    const SizedBox(height: 26),
                    _MonthSelector(recordingCount: _recordings.length),
                    const SizedBox(height: 24),

                    if (_isRecordingsLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (_recordings.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 40),
                          child: Text(
                            '아직 업로드된 녹음이 없어요.',
                            style: TextStyle(
                              fontSize: 14,
                              color: ArchiveScreen.subText,
                            ),
                          ),
                        ),
                      )
                    else
                      ..._recordings.map(
                        (recording) => Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: _RecordingTile(
                            recording: recording,
                            personName: selectedSubject.displayName,
                            onTap: () {
                              final item = RecordingItem(
                                title: recording.originalFilename.isNotEmpty
                                    ? recording.originalFilename
                                    : '${selectedSubject.displayName}의 녹음',
                                person: selectedSubject.displayName,
                                date: _formatDate(recording.createdAt),
                                duration: _formatDuration(
                                  recording.durationSeconds,
                                ),
                                tag: '# 녹음',
                              );

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      RecordingDetailScreen(record: item),
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
            const BottomNavBar(currentTab: BottomNavTab.archive),
          ],
        ),
      ),
    );
  }

  String _formatDate(String value) {
    if (value.isEmpty) return '-';

    final date = DateTime.tryParse(value);
    if (date == null) return '-';

    return '${date.month}월 ${date.day}일';
  }

  String _formatDuration(int? seconds) {
    if (seconds == null || seconds <= 0) return '--:--';

    final minutes = seconds ~/ 60;
    final remainSeconds = seconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:${remainSeconds.toString().padLeft(2, '0')}';
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

class _SubjectChips extends StatelessWidget {
  final List<Subject> subjects;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const _SubjectChips({
    required this.subjects,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(subjects.length, (index) {
          final subject = subjects[index];
          final selected = selectedIndex == index;

          return Padding(
            padding: EdgeInsets.only(
              right: index == subjects.length - 1 ? 0 : 10,
            ),
            child: GestureDetector(
              onTap: () => onSelected(index),
              child: _FilterChip(
                label: subject.displayName,
                selected: selected,
              ),
            ),
          );
        }),
      ),
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
  final int recordingCount;

  const _MonthSelector({required this.recordingCount});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _SquareIconButton(icon: Icons.chevron_left_rounded, onTap: () {}),
        Expanded(
          child: Column(
            children: [
              const Text(
                '2026년 7월',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: ArchiveScreen.darkText,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '녹음 $recordingCount개',
                style: const TextStyle(
                  fontSize: 12,
                  color: ArchiveScreen.subText,
                ),
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE9E3DA)),
        ),
        child: Icon(icon, size: 24, color: const Color(0xFF222222)),
      ),
    );
  }
}

class _RecordingTile extends StatelessWidget {
  final Recording recording;
  final String personName;
  final VoidCallback onTap;

  const _RecordingTile({
    required this.recording,
    required this.personName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final title = recording.originalFilename.isNotEmpty
        ? recording.originalFilename
        : '$personName의 녹음';

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
                      text: '$title\n',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: ArchiveScreen.darkText,
                      ),
                    ),
                    TextSpan(
                      text: '$personName · ${recording.uploadStatus}',
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
