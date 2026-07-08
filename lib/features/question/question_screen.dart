import 'package:flutter/material.dart';

import '../../shared/widgets/bottom_nav_bar.dart';

class QuestionScreen extends StatefulWidget {
  final String profileName;
  final String question;

  const QuestionScreen({
    super.key,
    required this.profileName,
    required this.question,
  });
  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<_SearchQuestionItem> _allQuestions = [
    _SearchQuestionItem('설날이나 추석에 가장 기다려졌던 일은 무엇이었어요?', '음식 / 명절'),
    _SearchQuestionItem('명절이면 꼭 만들던 음식이 있었어요?', '음식 / 명절', completed: true),
    _SearchQuestionItem('어릴 때 명절에 친척들과 어떤 놀이를 했어요?', '어린 시절'),
    _SearchQuestionItem('가족이 모두 모였던 명절 중 가장 기억나는 날 있어요?', '가족 관계'),
    _SearchQuestionItem('고향에서 가장 기억나는 장소는 어딘가요?', '남기고 싶은 말'),
    _SearchQuestionItem('명절 준비를 하며 가장 힘들었던 점은 무엇이었어요?', '가족 관계'),
  ];

  String _searchText = '';

  List<_SearchQuestionItem> get _filteredQuestions {
    final keyword = _searchText.trim();
    if (keyword.isEmpty) return [];

    return _allQuestions.where((item) {
      return item.question.contains(keyword) || item.category.contains(keyword);
    }).toList();
  }

  void _toggleQuestion(_SearchQuestionItem item) {
    setState(() {
      item.completed = !item.completed;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  static const Color primary = Color(0xFF22CC7A);
  static const Color subText = Color(0xFF7C8273);
  static const Color darkText = Color(0xFF222222);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFCF8),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(32, 18, 32, 22),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 255, 255, 255),
                border: Border(bottom: BorderSide(color: Color(0xFFE5E5E5))),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '이야기 질문',
                          style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.w700,
                            color: darkText,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          '질문은 다른 서비스와 연결되지 않아요',
                          style: TextStyle(fontSize: 12, color: subText),
                        ),
                      ],
                    ),
                  ),
                  CircleAvatar(
                    radius: 32,
                    backgroundImage: NetworkImage(
                      widget.profileName.contains('아버지') ||
                              widget.profileName.contains('할아버지')
                          ? 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200'
                          : 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200',
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(28, 34, 28, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '오늘의 질문',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: primary,
                      ),
                    ),
                    const SizedBox(height: 29),
                    _SearchBox(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          _searchText = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '오늘 편할 때 직접 물어보고, 나중에 체크만 해주세요.',
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.6,
                        color: subText,
                      ),
                    ),
                    const SizedBox(height: 28),

                    _searchText.trim().isEmpty
                        ? const _QuestionCategorySection()
                        : _SearchResultSection(
                            keyword: _searchText.trim(),
                            questions: _filteredQuestions,
                            onToggle: _toggleQuestion,
                          ),
                  ],
                ),
              ),
            ),

            const BottomNavBar(currentTab: BottomNavTab.home),
          ],
        ),
      ),
    );
  }
}

class _QuestionCategorySection extends StatefulWidget {
  const _QuestionCategorySection();

  @override
  State<_QuestionCategorySection> createState() =>
      _QuestionCategorySectionState();
}

class _QuestionCategorySectionState extends State<_QuestionCategorySection> {
  int? _expandedIndex = 0;

  final List<_QuestionCategory> _categories = [
    _QuestionCategory(
      title: '어린 시절',
      icon: Icons.home_outlined,
      questions: [
        _QuestionItem('태어나고 자란 고향은 어떤 곳이었어요?', true),
        _QuestionItem('어릴 때 살던 집은 어떤 모습이었어요?', false),
        _QuestionItem('어릴 때 가장 선명하게 기억나는 하루가 있나요?', false),
        _QuestionItem('동네 친구들과 주로 무엇을 하고 놀았어요?', true),
        _QuestionItem('고향에서 가장 기억나는 장소는 어딘가요?', false),
      ],
    ),
    _QuestionCategory(
      title: '부모님 / 형제',
      icon: Icons.groups_outlined,
      questions: [
        _QuestionItem('부모님은 어떤 분들이셨어요?', true),
        _QuestionItem('형제자매들과는 어떻게 지내셨어요?', false),
        _QuestionItem('가족과 함께한 가장 따뜻한 기억은 무엇인가요?', false),
      ],
    ),
    _QuestionCategory(
      title: '학창시절',
      icon: Icons.menu_book_outlined,
      questions: [
        _QuestionItem('학교 다닐 때 가장 좋아했던 과목은 뭐였어요?', false),
        _QuestionItem('기억나는 선생님이 있으세요?', false),
        _QuestionItem('친구들과 자주 하던 일은 무엇이었나요?', true),
      ],
    ),
    _QuestionCategory(
      title: '음식',
      icon: Icons.ramen_dining_outlined,
      questions: [
        _QuestionItem('어릴 때 가장 좋아했던 음식은 뭐였어요?', false),
        _QuestionItem('집에서 자주 먹던 음식은 무엇이었나요?', true),
      ],
    ),
    _QuestionCategory(
      title: '성격',
      icon: Icons.chat_bubble_outline,
      questions: [
        _QuestionItem('어릴 때 성격은 어떤 편이었나요?', false),
        _QuestionItem('가장 많이 들었던 말은 무엇이었어요?', true),
      ],
    ),
  ];

  int get totalCount =>
      _categories.fold(0, (sum, category) => sum + category.questions.length);

  int get completedCount => _categories.fold(
    0,
    (sum, category) =>
        sum + category.questions.where((q) => q.completed).length,
  );

  int get remainingCount => totalCount - completedCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: '$completedCount개 ',
                style: const TextStyle(
                  color: Color(0xFF22CC7A),
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const TextSpan(
                text: '완료했어요',
                style: TextStyle(
                  color: Color(0xFF222222),
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        Row(
          children: [
            _FilterChip(label: '전체 $totalCount', selected: true),
            const SizedBox(width: 12),
            _FilterChip(label: '남은 질문 $remainingCount'),
            const SizedBox(width: 12),
            _FilterChip(label: '완료 $completedCount'),
          ],
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: const Color(0xFFF1E7DA)),
          ),
          child: Column(
            children: List.generate(_categories.length, (index) {
              final category = _categories[index];
              final expanded = _expandedIndex == index;

              return Column(
                children: [
                  _CategoryTile(
                    item: category,
                    expanded: expanded,
                    onTap: () {
                      setState(() {
                        _expandedIndex = expanded ? null : index;
                      });
                    },
                  ),
                  AnimatedCrossFade(
                    duration: const Duration(milliseconds: 180),
                    crossFadeState: expanded
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    firstChild: const SizedBox.shrink(),
                    secondChild: Padding(
                      padding: const EdgeInsets.only(top: 18, bottom: 6),
                      child: Column(
                        children: List.generate(category.questions.length, (
                          qIndex,
                        ) {
                          final question = category.questions[qIndex];

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _QuestionCheckTile(
                              question: question,
                              onTap: () {
                                setState(() {
                                  question.completed = !question.completed;
                                });
                              },
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                  if (index != _categories.length - 1)
                    const Divider(height: 26, color: Color(0xFFF1E7DA)),
                ],
              );
            }),
          ),
        ),
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
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: selected ? const Color(0xFF22CC7A) : Colors.white,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: selected ? const Color(0xFF22CC7A) : const Color(0xFF7C8672),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: selected ? Colors.white : const Color(0xFF7C8672),
        ),
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final _QuestionCategory item;
  final bool expanded;
  final VoidCallback onTap;

  const _CategoryTile({
    required this.item,
    required this.expanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final completed = item.questions.where((q) => q.completed).length;
    final total = item.questions.length;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: const BoxDecoration(
              color: Color(0xFF22CC7A),
              shape: BoxShape.circle,
            ),
            child: Icon(item.icon, color: Colors.white, size: 27),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '${item.title}\n',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF222222),
                    ),
                  ),
                  TextSpan(
                    text: expanded
                        ? '$completed개 완료 / ${total - completed}개 남음'
                        : '$total개 질문',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF7C8273),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F8EF),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text(
              '$completed/$total',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF22CC7A),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Icon(
            expanded
                ? Icons.keyboard_arrow_down_rounded
                : Icons.chevron_right_rounded,
            size: 28,
            color: const Color(0xFF7C8273),
          ),
        ],
      ),
    );
  }
}

class _QuestionCheckTile extends StatelessWidget {
  final _QuestionItem question;
  final VoidCallback onTap;

  const _QuestionCheckTile({required this.question, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final completed = question.completed;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        decoration: BoxDecoration(
          color: completed ? const Color(0xFFE2E8DF) : Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: completed ? const Color(0xFF22CC7A) : Colors.white,
                border: Border.all(
                  color: completed
                      ? const Color(0xFF22CC7A)
                      : const Color(0xFFDDE3DA),
                  width: 2,
                ),
              ),
              child: completed
                  ? const Icon(Icons.check, color: Colors.white, size: 28)
                  : null,
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '${question.text}\n',
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.35,
                        fontWeight: FontWeight.w600,
                        color: completed
                            ? const Color(0xFF7C8273)
                            : const Color(0xFF222222),
                      ),
                    ),
                    TextSpan(
                      text: completed ? '완료됨 / 다시 누르면 취소' : '남은 질문',
                      style: const TextStyle(
                        fontSize: 12,
                        height: 1.5,
                        color: Color(0xFF7C8273),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuestionCategory {
  final String title;
  final IconData icon;
  final List<_QuestionItem> questions;

  _QuestionCategory({
    required this.title,
    required this.icon,
    required this.questions,
  });
}

class _QuestionItem {
  final String text;
  bool completed;

  _QuestionItem(this.text, this.completed);
}

class _SearchBox extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _SearchBox({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: const Color(0xFF7C8672), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF22CC7A).withOpacity(0.16),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.search, size: 28, color: Color(0xFF7C8672)),
          const SizedBox(width: 14),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              decoration: const InputDecoration(
                hintText: '질문이나 주제를 검색해보세요',
                border: InputBorder.none,
                hintStyle: TextStyle(fontSize: 14, color: Color(0xFF999999)),
              ),
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF222222),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchResultSection extends StatelessWidget {
  final String keyword;
  final List<_SearchQuestionItem> questions;
  final ValueChanged<_SearchQuestionItem> onToggle;

  const _SearchResultSection({
    required this.keyword,
    required this.questions,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 28),
        child: Center(
          child: Text(
            '\'$keyword\' 관련 질문이 없어요',
            style: const TextStyle(fontSize: 15, color: Color(0xFF7C8273)),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '\'$keyword\' 질문 ${questions.length}개',
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Color(0xFF222222),
              ),
            ),
            const Spacer(),
            const Text(
              '체크 상태도 그대로 보여요',
              style: TextStyle(fontSize: 12, color: Color(0xFF7C8273)),
            ),
          ],
        ),
        const SizedBox(height: 18),
        ...questions.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _SearchQuestionTile(item: item, onTap: () => onToggle(item)),
          ),
        ),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: const Color(0xFFD6A85A)),
          ),
          child: const Text(
            '검색 결과에서도 별도 상세 화면이나 녹음 연결 없이 체크만 할 수 있어요.',
            style: TextStyle(fontSize: 12, color: Color(0xFF9A7A45)),
          ),
        ),
      ],
    );
  }
}

class _SearchQuestionTile extends StatelessWidget {
  final _SearchQuestionItem item;
  final VoidCallback onTap;

  const _SearchQuestionTile({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final completed = item.completed;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: completed ? const Color(0xFFE2E8DF) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: completed
                ? const Color(0xFFE2E8DF)
                : const Color(0xFFE5E5E5),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: completed ? const Color(0xFF22CC7A) : Colors.white,
                border: Border.all(
                  color: completed
                      ? const Color(0xFF22CC7A)
                      : const Color(0xFFDDE3DA),
                  width: 2,
                ),
              ),
              child: completed
                  ? const Icon(Icons.check, color: Colors.white, size: 28)
                  : null,
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '${item.question}\n',
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.35,
                        fontWeight: FontWeight.w600,
                        color: completed
                            ? const Color(0xFF7C8273)
                            : const Color(0xFF222222),
                      ),
                    ),
                    TextSpan(
                      text: item.category,
                      style: const TextStyle(
                        fontSize: 12,
                        height: 1.5,
                        color: Color(0xFF7C8273),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchQuestionItem {
  final String question;
  final String category;
  bool completed;

  _SearchQuestionItem(this.question, this.category, {this.completed = false});
}
