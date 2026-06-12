import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/models.dart';
import '../../../providers/app_provider.dart';

class MatchingGameScreen extends StatefulWidget {
  final TopicData topic;
  const MatchingGameScreen({super.key, required this.topic});

  @override
  State<MatchingGameScreen> createState() => _MatchingGameScreenState();
}

class _MatchingGameScreenState extends State<MatchingGameScreen> {
  late List<VocabularyWord> _gameWords;
  late List<String> _englishList;
  late List<String> _vietnameseList;
  String? _selectedEnglish;
  String? _selectedVietnamese;
  Set<String> _matchedPairs = {};
  int _score = 0;
  int _attempts = 0;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    _setupGame();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _setupGame() {
    _gameWords = List.from(widget.topic.words)..shuffle(Random());
    if (_gameWords.length > 6) _gameWords = _gameWords.sublist(0, 6);
    _englishList = _gameWords.map((w) => w.english).toList()..shuffle(Random());
    _vietnameseList = _gameWords.map((w) => w.vietnamese).toList()..shuffle(Random());
    _matchedPairs = {};
    _selectedEnglish = null;
    _selectedVietnamese = null;
    _score = 0;
    _attempts = 0;
  }

  void _selectEnglish(String word) {
    if (_matchedPairs.contains(word)) return;
    setState(() { _selectedEnglish = word; });
    _checkMatch();
  }

  void _selectVietnamese(String word) {
    if (_matchedPairs.contains(word)) return;
    setState(() { _selectedVietnamese = word; });
    _checkMatch();
  }

  void _checkMatch() {
    if (_selectedEnglish == null || _selectedVietnamese == null) return;
    _attempts++;
    final matchWord = _gameWords.firstWhere((w) => w.english == _selectedEnglish, orElse: () => _gameWords.first);

    if (matchWord.english == _selectedEnglish && matchWord.vietnamese == _selectedVietnamese) {
      final appProvider = context.read<AppProvider>();
      appProvider.speak(_selectedEnglish!);
      appProvider.markWordLearned(_selectedEnglish!);
      setState(() {
        _matchedPairs.add(_selectedEnglish!);
        _matchedPairs.add(_selectedVietnamese!);
        _score += 15;
        _selectedEnglish = null;
        _selectedVietnamese = null;
      });
      if (_matchedPairs.length == _gameWords.length * 2) {
        _confettiController.play();
        appProvider.saveGameResult(
          topic: widget.topic.id, game: 'matching', score: _score,
          totalQuestions: _gameWords.length, correctAnswers: _gameWords.length);
        Future.delayed(const Duration(milliseconds: 500), () { if (mounted) _showResult(); });
      }
    } else {
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) setState(() { _selectedEnglish = null; _selectedVietnamese = null; });
      });
    }
  }

  void _showResult() {
    showDialog(context: context, barrierDismissible: false,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        backgroundColor: AppColors.surfaceContainerLowest,
        child: Padding(padding: const EdgeInsets.all(32),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(width: 64, height: 64,
              decoration: const BoxDecoration(color: AppColors.primaryFixed, shape: BoxShape.circle),
              child: const Icon(Icons.extension_rounded, color: AppColors.primary, size: 32)),
            const SizedBox(height: 16),
            const Text('Hoàn thành!', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.onSurface)),
            const SizedBox(height: 6),
            Text('Đã ghép ${_gameWords.length} cặp trong $_attempts lần thử',
              style: const TextStyle(fontSize: 14, color: AppColors.onSurfaceVariant, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            Row(mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (i) {
                int stars = _attempts <= _gameWords.length ? 3 : _attempts <= _gameWords.length * 2 ? 2 : 1;
                return Icon(i < stars ? Icons.star_rounded : Icons.star_outline_rounded,
                  color: i < stars ? AppColors.tertiary : AppColors.outlineVariant, size: 28);
              })),
            const SizedBox(height: 12),
            Text('+$_score điểm', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.primary)),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () {
                Navigator.of(ctx).pop();
                Navigator.of(context).pop();
              },
              child: Container(
                width: double.infinity,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(16),
                  border: const Border(
                    bottom: BorderSide(
                      color: Color(0xFF5516BE), // Tím thẫm hơn
                      width: 4,
                    ),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Hoàn thành',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
          ]))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Stack(children: [
        SafeArea(child: Column(children: [
          Padding(padding: const EdgeInsets.all(24), child: Row(children: [
            GestureDetector(onTap: () => Navigator.pop(context),
              child: Container(width: 44, height: 44,
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.close_rounded, color: Colors.white))),
            const Spacer(),
            const Text('Ghép hình', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
            const Spacer(),
            Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
              child: Text('$_score', style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w800))),
          ])),
          const SizedBox(height: 8),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 24),
            child: const Text('Ghép từ tiếng Anh với nghĩa tiếng Việt tương ứng',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600))),
          const SizedBox(height: 16),
          // Progress
          Padding(padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ClipRRect(borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: _matchedPairs.length / (_gameWords.length * 2),
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white), minHeight: 6))),
          const SizedBox(height: 24),
          // Game columns
          Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(children: [
              // English column
              Expanded(child: ListView.builder(
                itemCount: _englishList.length,
                itemBuilder: (ctx, index) {
                  String word = _englishList[index];
                  bool isMatched = _matchedPairs.contains(word);
                  bool isSelected = _selectedEnglish == word;
                  return Padding(padding: const EdgeInsets.only(bottom: 12),
                    child: GestureDetector(
                      onTap: isMatched ? null : () => _selectEnglish(word),
                      child: AnimatedContainer(duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isMatched
                              ? AppColors.secondaryContainer
                              : isSelected ? Colors.white : AppColors.surfaceContainerLowest,
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.secondary
                                : isMatched ? AppColors.secondary : AppColors.outlineVariant,
                            width: 2,
                          ),
                        ),
                        child: Center(child: Text(word,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800,
                            color: isMatched ? AppColors.onSecondaryContainer : AppColors.onSurface,
                            decoration: isMatched ? TextDecoration.lineThrough : null))))));
                })),
              const SizedBox(width: 14),
              // Vietnamese column
              Expanded(child: ListView.builder(
                itemCount: _vietnameseList.length,
                itemBuilder: (ctx, index) {
                  String word = _vietnameseList[index];
                  bool isMatched = _matchedPairs.contains(word);
                  bool isSelected = _selectedVietnamese == word;
                  return Padding(padding: const EdgeInsets.only(bottom: 12),
                    child: GestureDetector(
                      onTap: isMatched ? null : () => _selectVietnamese(word),
                      child: AnimatedContainer(duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isMatched
                              ? AppColors.secondaryContainer
                              : isSelected ? Colors.white : AppColors.surfaceContainerLowest,
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.secondary
                                : isMatched ? AppColors.secondary : AppColors.outlineVariant,
                            width: 2,
                          ),
                        ),
                        child: Center(child: Text(word,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800,
                            color: isMatched ? AppColors.onSecondaryContainer : AppColors.onSurface,
                            decoration: isMatched ? TextDecoration.lineThrough : null))))));
                })),
            ]))),
        ])),
        Align(alignment: Alignment.topCenter,
          child: ConfettiWidget(confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive, numberOfParticles: 25,
            colors: const [AppColors.primary, AppColors.secondary, AppColors.tertiary])),
      ]));
  }
}
