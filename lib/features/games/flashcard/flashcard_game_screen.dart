import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/models.dart';
import '../../../providers/app_provider.dart';

class FlashcardGameScreen extends StatefulWidget {
  final TopicData topic;
  const FlashcardGameScreen({super.key, required this.topic});

  @override
  State<FlashcardGameScreen> createState() => _FlashcardGameScreenState();
}

class _FlashcardGameScreenState extends State<FlashcardGameScreen>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  bool _isFlipped = false;
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;
  late ConfettiController _confettiController;
  int _learnedCount = 0;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 500));
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOut));
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _flipController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  void _flipCard() {
    if (_isFlipped) {
      _flipController.reverse();
    } else {
      _flipController.forward();
    }
    setState(() { _isFlipped = !_isFlipped; });
  }

  void _nextCard() {
    final appProvider = context.read<AppProvider>();
    _learnedCount++;
    appProvider.markWordLearned(widget.topic.words[_currentIndex].english);
    if (_currentIndex < widget.topic.words.length - 1) {
      setState(() { _currentIndex++; _isFlipped = false; });
      _flipController.reset();
    } else {
      _confettiController.play();
      appProvider.saveGameResult(
        topic: widget.topic.id, game: 'flashcard',
        score: _learnedCount * 10,
        totalQuestions: widget.topic.words.length,
        correctAnswers: _learnedCount,
      );
      _showCompletionDialog();
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context, barrierDismissible: false,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(width: 80, height: 80,
              decoration: const BoxDecoration(gradient: AppColors.sunsetGradient, shape: BoxShape.circle),
              child: const Icon(Icons.celebration_rounded, color: Colors.white, size: 40)),
            const SizedBox(height: 20),
            const Text('Tuyet voi!', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text('Con da hoc ${widget.topic.words.length} tu moi!',
              style: const TextStyle(fontSize: 16, color: AppColors.textSecondary)),
            const SizedBox(height: 8),
            Row(mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (_) => const Icon(Icons.star_rounded, color: AppColors.starGold, size: 36))),
            const SizedBox(height: 8),
            Text('+${_learnedCount * 10} diem',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.primaryGreen)),
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
    final word = widget.topic.words[_currentIndex];
    final appProvider = context.read<AppProvider>();
    return Scaffold(
      body: Stack(children: [
        Container(
          decoration: const BoxDecoration(gradient: LinearGradient(
            colors: [Color(0xFF6C5CE7), Color(0xFFA29BFE)],
            begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: SafeArea(child: Column(children: [
            Padding(padding: const EdgeInsets.all(16), child: Row(children: [
              GestureDetector(onTap: () => Navigator.pop(context),
                child: Container(width: 44, height: 44,
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(14)),
                  child: const Icon(Icons.close_rounded, color: Colors.white))),
              const SizedBox(width: 16),
              Expanded(child: Column(children: [
                Text('${_currentIndex + 1}/${widget.topic.words.length}',
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                ClipRRect(borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: (_currentIndex + 1) / widget.topic.words.length,
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white), minHeight: 6)),
              ])),
              const SizedBox(width: 16),
              GestureDetector(onTap: () => appProvider.speak(word.english),
                child: Container(width: 44, height: 44,
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(14)),
                  child: const Icon(Icons.volume_up_rounded, color: Colors.white))),
            ])),
            const SizedBox(height: 20),
            Text(_isFlipped ? 'Nghia tieng Viet' : 'Nhan de lat the!',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(height: 24),
            Expanded(child: GestureDetector(onTap: _flipCard,
              child: AnimatedBuilder(animation: _flipAnimation,
                builder: (ctx, _) {
                  double angle = _flipAnimation.value * 3.14159;
                  bool showBack = _flipAnimation.value > 0.5;
                  return Transform(alignment: Alignment.center,
                    transform: Matrix4.identity()..setEntry(3, 2, 0.001)..rotateY(angle),
                    child: Container(margin: const EdgeInsets.symmetric(horizontal: 32),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(32),
                        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 30, offset: const Offset(0, 15))]),
                      child: Center(child: showBack
                        ? Transform(alignment: Alignment.center, transform: Matrix4.identity()..rotateY(3.14159),
                          child: _buildBackCard(word))
                        : _buildFrontCard(word))));
                }))),
            const SizedBox(height: 24),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                GestureDetector(onTap: _currentIndex > 0 ? () { setState(() { _currentIndex--; _isFlipped = false; }); _flipController.reset(); } : null,
                  child: Container(width: 60, height: 60,
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), shape: BoxShape.circle),
                    child: Icon(Icons.arrow_back_rounded, color: _currentIndex > 0 ? Colors.white : Colors.white.withValues(alpha: 0.3), size: 28))),
                GestureDetector(onTap: () => appProvider.speak(word.english),
                  child: Container(width: 70, height: 70,
                    decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 12, offset: const Offset(0, 4))]),
                    child: const Icon(Icons.volume_up_rounded, color: AppColors.primaryPurple, size: 32))),
                GestureDetector(onTap: _nextCard,
                  child: Container(width: 60, height: 60,
                    decoration: const BoxDecoration(color: AppColors.primaryGreen, shape: BoxShape.circle),
                    child: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 28))),
              ])),
            const SizedBox(height: 32),
          ]))),
        Align(alignment: Alignment.topCenter,
          child: ConfettiWidget(confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive, maxBlastForce: 30, minBlastForce: 10, numberOfParticles: 30,
            colors: const [AppColors.primaryPink, AppColors.primaryYellow, AppColors.primaryGreen, AppColors.primaryBlue])),
      ]));
  }

  Widget _buildFrontCard(VocabularyWord word) {
    return Padding(padding: const EdgeInsets.all(32), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(width: 100, height: 100,
        decoration: const BoxDecoration(gradient: AppColors.skyGradient, shape: BoxShape.circle),
        child: Center(child: Text(word.emoji, style: const TextStyle(fontSize: 42, fontWeight: FontWeight.w900, color: Colors.white)))),
      const SizedBox(height: 28),
      Text(word.english, textAlign: TextAlign.center, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
      const SizedBox(height: 16),
      Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(color: AppColors.primaryPurple.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
        child: const Text('Nhan de xem nghia', style: TextStyle(color: AppColors.primaryPurple, fontSize: 14, fontWeight: FontWeight.w500))),
    ]));
  }

  Widget _buildBackCard(VocabularyWord word) {
    return Padding(padding: const EdgeInsets.all(32), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(width: 80, height: 80,
        decoration: const BoxDecoration(gradient: AppColors.warmGradient, shape: BoxShape.circle),
        child: const Icon(Icons.translate_rounded, color: Colors.white, size: 36)),
      const SizedBox(height: 28),
      Text(word.english, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
      const SizedBox(height: 12),
      Container(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(color: AppColors.primaryGreen.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(16)),
        child: Text(word.vietnamese, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.primaryGreen))),
    ]));
  }
}

class AnimatedBuilder extends AnimatedWidget {
  final Widget Function(BuildContext context, Widget? child) builder;
  final Widget? child;
  const AnimatedBuilder({super.key, required Animation<double> animation, required this.builder, this.child}) : super(listenable: animation);
  @override
  Widget build(BuildContext context) => builder(context, child);
}
