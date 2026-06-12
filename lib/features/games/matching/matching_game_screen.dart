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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: Padding(padding: const EdgeInsets.all(28),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(width: 80, height: 80,
              decoration: const BoxDecoration(gradient: AppColors.forestGradient, shape: BoxShape.circle),
              child: const Icon(Icons.extension_rounded, color: Colors.white, size: 40)),
            const SizedBox(height: 20),
            const Text('Hoan thanh!', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text('Da ghep ${_gameWords.length} cap trong $_attempts lan thu',
              style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
            const SizedBox(height: 12),
            Row(mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (i) {
                int stars = _attempts <= _gameWords.length ? 3 : _attempts <= _gameWords.length * 2 ? 2 : 1;
                return Icon(i < stars ? Icons.star_rounded : Icons.star_outline_rounded,
                  color: i < stars ? AppColors.starGold : AppColors.textHint, size: 36);
              })),
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
    return Scaffold(
      body: Stack(children: [
        Container(
          decoration: const BoxDecoration(gradient: LinearGradient(
            colors: [Color(0xFF00B894), Color(0xFF55EFC4)],
            begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: SafeArea(child: Column(children: [
            Padding(padding: const EdgeInsets.all(16), child: Row(children: [
              GestureDetector(onTap: () => Navigator.pop(context),
                child: Container(width: 44, height: 44,
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(14)),
                  child: const Icon(Icons.close_rounded, color: Colors.white))),
              const Spacer(),
              const Text('Ghep hinh', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
              const Spacer(),
              Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(16)),
                child: Text('$_score', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700))),
            ])),
            const SizedBox(height: 8),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text('Ghep tu tieng Anh voi nghia tieng Viet',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14))),
            const SizedBox(height: 16),
            // Progress
            Padding(padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ClipRRect(borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: _matchedPairs.length / (_gameWords.length * 2),
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white), minHeight: 6))),
            const SizedBox(height: 20),
            // Game columns
            Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(children: [
                // English column
                Expanded(child: ListView.builder(
                  itemCount: _englishList.length,
                  itemBuilder: (ctx, index) {
                    String word = _englishList[index];
                    bool isMatched = _matchedPairs.contains(word);
                    bool isSelected = _selectedEnglish == word;
                    return Padding(padding: const EdgeInsets.only(bottom: 10),
                      child: GestureDetector(
                        onTap: isMatched ? null : () => _selectEnglish(word),
                        child: AnimatedContainer(duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: isMatched ? AppColors.primaryGreen.withValues(alpha: 0.2) : isSelected ? Colors.white : Colors.white.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: isSelected ? AppColors.primaryBlue : Colors.transparent, width: 3),
                            boxShadow: isMatched ? [] : [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 6, offset: const Offset(0, 3))]),
                          child: Center(child: Text(word,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700,
                              color: isMatched ? AppColors.primaryGreen : AppColors.textPrimary,
                              decoration: isMatched ? TextDecoration.lineThrough : null))))));
                  })),
                const SizedBox(width: 12),
                // Vietnamese column
                Expanded(child: ListView.builder(
                  itemCount: _vietnameseList.length,
                  itemBuilder: (ctx, index) {
                    String word = _vietnameseList[index];
                    bool isMatched = _matchedPairs.contains(word);
                    bool isSelected = _selectedVietnamese == word;
                    return Padding(padding: const EdgeInsets.only(bottom: 10),
                      child: GestureDetector(
                        onTap: isMatched ? null : () => _selectVietnamese(word),
                        child: AnimatedContainer(duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: isMatched ? AppColors.primaryGreen.withValues(alpha: 0.2) : isSelected ? Colors.white : Colors.white.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: isSelected ? AppColors.primaryOrange : Colors.transparent, width: 3),
                            boxShadow: isMatched ? [] : [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 6, offset: const Offset(0, 3))]),
                          child: Center(child: Text(word,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600,
                              color: isMatched ? AppColors.primaryGreen : AppColors.textPrimary,
                              decoration: isMatched ? TextDecoration.lineThrough : null))))));
                  })),
              ]))),
          ]))),
        Align(alignment: Alignment.topCenter,
          child: ConfettiWidget(confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive, numberOfParticles: 25,
            colors: const [AppColors.primaryPink, AppColors.primaryYellow, AppColors.primaryGreen])),
      ]));
  }
}
