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

  @override
  void initState() {
    super.initState();
    _shuffledWords = List.from(widget.topic.words)..shuffle(Random());
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  List<String> _getOptions() {
    final correct = _shuffledWords[_currentIndex].vietnamese;
    List<String> allVietnamese = widget.topic.words.map((w) => w.vietnamese).toList();
    allVietnamese.remove(correct);
    allVietnamese.shuffle(Random());
    List<String> options = [correct, ...allVietnamese.take(3)];
    options.shuffle(Random());
    return options;
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
    if (_correctCount / totalQ >= 0.9) stars = 3;
    else if (_correctCount / totalQ >= 0.7) stars = 2;
    else if (_correctCount / totalQ >= 0.5) stars = 1;

    showDialog(context: context, barrierDismissible: false,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: Padding(padding: const EdgeInsets.all(28),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(width: 80, height: 80,
              decoration: BoxDecoration(
                gradient: stars >= 2 ? AppColors.sunsetGradient : AppColors.coolGradient, shape: BoxShape.circle),
              child: Icon(stars >= 2 ? Icons.emoji_events_rounded : Icons.thumb_up_rounded, color: Colors.white, size: 40)),
            const SizedBox(height: 20),
            Text(stars >= 2 ? 'Xuat sac!' : stars >= 1 ? 'Gioi lam!' : 'Co len nhe!',
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text('$_correctCount/$totalQ cau dung',
              style: const TextStyle(fontSize: 16, color: AppColors.textSecondary)),
            const SizedBox(height: 12),
            Row(mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (i) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Icon(i < stars ? Icons.star_rounded : Icons.star_outline_rounded,
                  color: i < stars ? AppColors.starGold : AppColors.textHint, size: 36)))),
            const SizedBox(height: 8),
            Text('+$_score diem', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.primaryGreen)),
            const SizedBox(height: 24),
            SizedBox(width: double.infinity, height: 50,
              child: ElevatedButton(
                onPressed: () { Navigator.of(ctx).pop(); Navigator.of(context).pop(); },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryPurple,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
                child: const Text('Hoan thanh', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)))),
          ]))));
  }

  @override
  Widget build(BuildContext context) {
    final word = _shuffledWords[_currentIndex];
    final options = _getOptions();
    int totalQ = min(widget.topic.words.length, 10);
    final optionColors = [AppColors.primaryBlue, AppColors.primaryPink, AppColors.primaryGreen, AppColors.primaryOrange];

    return Scaffold(
      body: Stack(children: [
        Container(
          decoration: const BoxDecoration(gradient: LinearGradient(
            colors: [Color(0xFFFF7675), Color(0xFFFD79A8)],
            begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: SafeArea(child: Column(children: [
            Padding(padding: const EdgeInsets.all(16), child: Row(children: [
              GestureDetector(onTap: () => Navigator.pop(context),
                child: Container(width: 44, height: 44,
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(14)),
                  child: const Icon(Icons.close_rounded, color: Colors.white))),
              const SizedBox(width: 16),
              Expanded(child: Column(children: [
                Text('${_currentIndex + 1}/$totalQ',
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                ClipRRect(borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(value: (_currentIndex + 1) / totalQ,
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white), minHeight: 6)),
              ])),
              const SizedBox(width: 16),
              Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(16)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.star_rounded, color: AppColors.starGold, size: 18),
                  const SizedBox(width: 4),
                  Text('$_score', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                ])),
            ])),
            const SizedBox(height: 20),
            // Question Card
            Container(margin: const EdgeInsets.symmetric(horizontal: 20), padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(28),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 20, offset: const Offset(0, 10))]),
              child: Column(children: [
                Container(width: 70, height: 70,
                  decoration: BoxDecoration(gradient: AppColors.skyGradient, shape: BoxShape.circle),
                  child: Center(child: Text(word.emoji, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: Colors.white)))),
                const SizedBox(height: 16),
                Text(word.english, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                const SizedBox(height: 8),
                const Text('Nghia la gi?', style: TextStyle(fontSize: 16, color: AppColors.textSecondary)),
              ])),
            const SizedBox(height: 24),
            // Options
            Expanded(child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: options.length,
              itemBuilder: (ctx, index) {
                bool isSelected = _selectedAnswer == index;
                bool isCorrect = options[index] == word.vietnamese;
                Color bgColor = Colors.white;
                Color borderColor = Colors.white;
                if (_answered) {
                  if (isCorrect) { bgColor = AppColors.primaryGreen.withValues(alpha: 0.15); borderColor = AppColors.primaryGreen; }
                  else if (isSelected) { bgColor = AppColors.primaryRed.withValues(alpha: 0.15); borderColor = AppColors.primaryRed; }
                }
                return Padding(padding: const EdgeInsets.only(bottom: 12),
                  child: GestureDetector(
                    onTap: () => _selectAnswer(index, options),
                    child: AnimatedContainer(duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: _answered ? borderColor : optionColors[index % 4].withValues(alpha: 0.3), width: 2),
                        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 3))]),
                      child: Row(children: [
                        Container(width: 36, height: 36,
                          decoration: BoxDecoration(color: optionColors[index % 4].withValues(alpha: 0.15), shape: BoxShape.circle),
                          child: Center(child: Text(String.fromCharCode(65 + index),
                            style: TextStyle(fontWeight: FontWeight.w700, color: optionColors[index % 4], fontSize: 16)))),
                        const SizedBox(width: 14),
                        Expanded(child: Text(options[index],
                          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: AppColors.textPrimary))),
                        if (_answered && isCorrect) const Icon(Icons.check_circle_rounded, color: AppColors.primaryGreen, size: 24),
                        if (_answered && isSelected && !isCorrect) const Icon(Icons.cancel_rounded, color: AppColors.primaryRed, size: 24),
                      ]))));
              })),
          ]))),
        Align(alignment: Alignment.topCenter,
          child: ConfettiWidget(confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive, numberOfParticles: 25,
            colors: const [AppColors.primaryPink, AppColors.primaryYellow, AppColors.primaryGreen, AppColors.primaryBlue])),
      ]));
  }
}
