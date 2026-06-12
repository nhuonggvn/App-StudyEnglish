import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/models.dart';
import '../../../providers/app_provider.dart';

class QuizGameScreen extends StatefulWidget {
  final TopicData topic;
  const QuizGameScreen({super.key, required this.topic});

  @override
  State<QuizGameScreen> createState() => _QuizGameScreenState();
}

class _QuizGameScreenState extends State<QuizGameScreen> {
  int _currentIndex = 0;
  int _correctCount = 0;
  int _score = 0;
  int? _selectedAnswer;
  bool _answered = false;
  late List<VocabularyWord> _shuffledWords;
  late ConfettiController _confettiController;
  late List<String> _currentOptions;
  int _lastOptionIndex = -1;

  @override
  void initState() {
    super.initState();
    _shuffledWords = List.from(widget.topic.words)..shuffle(Random());
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    _generateOptions();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _generateOptions() {
    final correct = _shuffledWords[_currentIndex].vietnamese;
    List<String> allVietnamese = widget.topic.words.map((w) => w.vietnamese).toList();
    allVietnamese.remove(correct);
    allVietnamese.shuffle(Random());
    List<String> options = [correct, ...allVietnamese.take(3)];
    options.shuffle(Random());
    _currentOptions = options;
    _lastOptionIndex = _currentIndex;
  }

  List<String> _getOptions() {
    if (_lastOptionIndex != _currentIndex) {
      _generateOptions();
    }
    return _currentOptions;
  }

  void _selectAnswer(int index, List<String> options) {
    if (_answered) return;
    final appProvider = context.read<AppProvider>();
    setState(() {
      _selectedAnswer = index;
      _answered = true;
    });

    bool isCorrect = options[index] == _shuffledWords[_currentIndex].vietnamese;
    if (isCorrect) {
      _correctCount++;
      _score += 20;
      appProvider.markWordLearned(_shuffledWords[_currentIndex].english);
    }
    appProvider.speak(_shuffledWords[_currentIndex].english);

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      if (_currentIndex < _shuffledWords.length - 1 && _currentIndex < 9) {
        setState(() {
          _currentIndex++;
          _selectedAnswer = null;
          _answered = false;
        });
      } else {
        _confettiController.play();
        appProvider.saveGameResult(
          topic: widget.topic.id, game: 'quiz', score: _score,
          totalQuestions: _currentIndex + 1, correctAnswers: _correctCount);
        _showResult();
      }
    });
  }

  void _showResult() {
    int totalQ = _currentIndex + 1;
    int stars = 0;
    if (_correctCount / totalQ >= 0.9) {
      stars = 3;
    } else if (_correctCount / totalQ >= 0.7) {
      stars = 2;
    } else if (_correctCount / totalQ >= 0.5) {
      stars = 1;
    }

    showDialog(context: context, barrierDismissible: false,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        backgroundColor: AppColors.surfaceContainerLowest,
        child: Padding(padding: const EdgeInsets.all(32),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(width: 64, height: 64,
              decoration: const BoxDecoration(
                color: AppColors.primaryFixed, shape: BoxShape.circle),
              child: Icon(stars >= 2 ? Icons.emoji_events_rounded : Icons.thumb_up_rounded, color: AppColors.primary, size: 32)),
            const SizedBox(height: 16),
            Text(stars >= 2 ? 'Xuất sắc!' : stars >= 1 ? 'Giỏi lắm!' : 'Cố lên nhé!',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.onSurface)),
            const SizedBox(height: 6),
            Text('$_correctCount/$totalQ câu đúng',
              style: const TextStyle(fontSize: 14, color: AppColors.onSurfaceVariant, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            Row(mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (i) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Icon(i < stars ? Icons.star_rounded : Icons.star_outline_rounded,
                  color: i < stars ? AppColors.tertiary : AppColors.outlineVariant, size: 28)))),
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
    final word = _shuffledWords[_currentIndex];
    final options = _getOptions();
    int totalQ = min(widget.topic.words.length, 10);
    final optionColors = [
      AppColors.primary,
      AppColors.secondary,
      AppColors.tertiary,
      AppColors.primaryContainer,
    ];

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Stack(children: [
        SafeArea(child: Column(children: [
          Padding(padding: const EdgeInsets.all(24), child: Row(children: [
            GestureDetector(onTap: () => Navigator.pop(context),
              child: Container(width: 44, height: 44,
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.close_rounded, color: Colors.white))),
            const SizedBox(width: 16),
            Expanded(child: Column(children: [
              Text('${_currentIndex + 1}/$totalQ',
                style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              ClipRRect(borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(value: (_currentIndex + 1) / totalQ,
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white), minHeight: 6)),
            ])),
            const SizedBox(width: 16),
            Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.star_rounded, color: AppColors.tertiary, size: 16),
                const SizedBox(width: 4),
                Text('$_score', style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w800)),
              ])),
          ])),
          const SizedBox(height: 16),
          // Question Card
          Container(margin: const EdgeInsets.symmetric(horizontal: 24), padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(32),
              border: Border.all(color: AppColors.outlineVariant, width: 1.5),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 15, offset: const Offset(0, 5))]),
            child: Column(children: [
              Container(width: 72, height: 72,
                decoration: const BoxDecoration(color: AppColors.primaryFixed, shape: BoxShape.circle),
                child: Center(child: Text(word.emoji, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)))),
              const SizedBox(height: 16),
              Text(word.english, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.onSurface, letterSpacing: -0.5)),
              const SizedBox(height: 4),
              const Text('Nghĩa là gì?', style: TextStyle(fontSize: 14, color: AppColors.onSurfaceVariant, fontWeight: FontWeight.w600)),
            ])),
          const SizedBox(height: 20),
          // Options
          Expanded(child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: options.length,
            itemBuilder: (ctx, index) {
              bool isSelected = _selectedAnswer == index;
              bool isCorrect = options[index] == word.vietnamese;
              Color bgColor = AppColors.surfaceContainerLowest;
              Color borderColor = AppColors.outlineVariant;
              Color labelColor = optionColors[index % 4];
              Color labelBg = optionColors[index % 4].withValues(alpha: 0.1);

              if (_answered) {
                if (isCorrect) {
                  bgColor = AppColors.secondaryContainer;
                  borderColor = AppColors.secondary;
                  labelColor = AppColors.onSecondaryContainer;
                  labelBg = Colors.white.withValues(alpha: 0.5);
                } else if (isSelected) {
                  bgColor = const Color(0xFFFFDAD9);
                  borderColor = AppColors.error;
                  labelColor = AppColors.error;
                  labelBg = Colors.white.withValues(alpha: 0.5);
                }
              }

              return Padding(padding: const EdgeInsets.only(bottom: 12),
                child: GestureDetector(
                  onTap: () => _selectAnswer(index, options),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(color: borderColor, width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: Row(children: [
                      Container(width: 32, height: 32,
                        decoration: BoxDecoration(color: labelBg, shape: BoxShape.circle),
                        child: Center(child: Text(String.fromCharCode(65 + index),
                          style: TextStyle(fontWeight: FontWeight.w800, color: labelColor, fontSize: 14)))),
                      const SizedBox(width: 14),
                      Expanded(child: Text(options[index],
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.onSurface))),
                      if (_answered && isCorrect) const Icon(Icons.check_circle_rounded, color: AppColors.secondary, size: 20),
                      if (_answered && isSelected && !isCorrect) const Icon(Icons.cancel_rounded, color: AppColors.error, size: 20),
                    ]))));
            })),
        ])),
        Align(alignment: Alignment.topCenter,
          child: ConfettiWidget(confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive, numberOfParticles: 25,
            colors: const [AppColors.primary, AppColors.secondary, AppColors.tertiary])),
      ]));
  }
}
