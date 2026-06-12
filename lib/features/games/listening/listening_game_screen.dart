import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/models.dart';
import '../../../providers/app_provider.dart';

class ListeningGameScreen extends StatefulWidget {
  final TopicData topic;
  const ListeningGameScreen({super.key, required this.topic});

  @override
  State<ListeningGameScreen> createState() => _ListeningGameScreenState();
}

class _ListeningGameScreenState extends State<ListeningGameScreen> {
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
    // Auto speak first word
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appProvider = context.read<AppProvider>();
      appProvider.speak(_shuffledWords[_currentIndex].english);
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  List<String> _getOptions() {
    final correct = _shuffledWords[_currentIndex].english;
    List<String> allEnglish = widget.topic.words.map((w) => w.english).toList();
    allEnglish.remove(correct);
    allEnglish.shuffle(Random());
    List<String> options = [correct, ...allEnglish.take(3)];
    options.shuffle(Random());
    return options;
  }

  void _selectAnswer(int index, List<String> options) {
    if (_answered) return;
    final appProvider = context.read<AppProvider>();
    setState(() { _selectedAnswer = index; _answered = true; });

    bool isCorrect = options[index] == _shuffledWords[_currentIndex].english;
    if (isCorrect) {
      _correctCount++;
      _score += 25;
      appProvider.markWordLearned(_shuffledWords[_currentIndex].english);
    }

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      int maxQ = min(widget.topic.words.length, 8);
      if (_currentIndex < maxQ - 1) {
        setState(() { _currentIndex++; _selectedAnswer = null; _answered = false; });
        appProvider.speak(_shuffledWords[_currentIndex].english);
      } else {
        _confettiController.play();
        appProvider.saveGameResult(
          topic: widget.topic.id, game: 'listening', score: _score,
          totalQuestions: maxQ, correctAnswers: _correctCount);
        _showResult();
      }
    });
  }

  void _showResult() {
    int maxQ = min(widget.topic.words.length, 8);
    int stars = _correctCount / maxQ >= 0.9 ? 3 : _correctCount / maxQ >= 0.7 ? 2 : _correctCount / maxQ >= 0.5 ? 1 : 0;
    showDialog(context: context, barrierDismissible: false,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: Padding(padding: const EdgeInsets.all(28),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(width: 80, height: 80,
              decoration: const BoxDecoration(gradient: AppColors.primaryGradient, shape: BoxShape.circle),
              child: const Icon(Icons.headphones_rounded, color: Colors.white, size: 40)),
            const SizedBox(height: 20),
            Text(stars >= 2 ? 'Tuyet voi!' : 'Co len nhe!',
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text('$_correctCount/$maxQ cau dung',
              style: const TextStyle(fontSize: 16, color: AppColors.textSecondary)),
            const SizedBox(height: 12),
            Row(mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (i) => Icon(
                i < stars ? Icons.star_rounded : Icons.star_outline_rounded,
                color: i < stars ? AppColors.starGold : AppColors.textHint, size: 36))),
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
    final appProvider = context.read<AppProvider>();
    final word = _shuffledWords[_currentIndex];
    final options = _getOptions();
    int maxQ = min(widget.topic.words.length, 8);

    return Scaffold(
      body: Stack(children: [
        Container(
          decoration: const BoxDecoration(gradient: LinearGradient(
            colors: [Color(0xFF0984E3), Color(0xFF74B9FF)],
            begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: SafeArea(child: Column(children: [
            // Header
            Padding(padding: const EdgeInsets.all(16), child: Row(children: [
              GestureDetector(onTap: () => Navigator.pop(context),
                child: Container(width: 44, height: 44,
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(14)),
                  child: const Icon(Icons.close_rounded, color: Colors.white))),
              const SizedBox(width: 16),
              Expanded(child: Column(children: [
                Text('${_currentIndex + 1}/$maxQ',
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                ClipRRect(borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(value: (_currentIndex + 1) / maxQ,
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
            const SizedBox(height: 32),
            // Speaker button
            GestureDetector(
              onTap: () => appProvider.speak(word.english),
              child: Container(width: 120, height: 120,
                decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 20, offset: const Offset(0, 8))]),
                child: const Icon(Icons.volume_up_rounded, color: Color(0xFF0984E3), size: 56))),
            const SizedBox(height: 16),
            Text('Nghe va chon dap an dung', style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 16)),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => appProvider.speakSlow(word.english),
              child: Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(20)),
                child: const Text('Nghe cham', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)))),
            const SizedBox(height: 24),
            // Options
            Expanded(child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: options.length,
              itemBuilder: (ctx, index) {
                bool isSelected = _selectedAnswer == index;
                bool isCorrect = options[index] == word.english;
                Color bgColor = Colors.white;
                if (_answered && isCorrect) bgColor = AppColors.primaryGreen.withValues(alpha: 0.15);
                if (_answered && isSelected && !isCorrect) bgColor = AppColors.primaryRed.withValues(alpha: 0.15);

                return Padding(padding: const EdgeInsets.only(bottom: 12),
                  child: GestureDetector(
                    onTap: () => _selectAnswer(index, options),
                    child: AnimatedContainer(duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _answered && isCorrect ? AppColors.primaryGreen : _answered && isSelected ? AppColors.primaryRed : Colors.transparent, width: 2),
                        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 3))]),
                      child: Row(children: [
                        Container(width: 36, height: 36,
                          decoration: BoxDecoration(color: AppColors.primaryBlue.withValues(alpha: 0.1), shape: BoxShape.circle),
                          child: Center(child: Text(String.fromCharCode(65 + index),
                            style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primaryBlue)))),
                        const SizedBox(width: 14),
                        Expanded(child: Text(options[index], style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600))),
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
