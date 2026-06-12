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
      vsync: this, duration: const Duration(milliseconds: 400));
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        backgroundColor: AppColors.surfaceContainerLowest,
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(width: 64, height: 64,
              decoration: const BoxDecoration(color: AppColors.primaryFixed, shape: BoxShape.circle),
              child: const Icon(Icons.celebration_rounded, color: AppColors.primary, size: 32)),
            const SizedBox(height: 16),
            const Text('Tuyệt vời!', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.onSurface)),
            const SizedBox(height: 6),
            Text('Con đã học xong tất cả từ mới!',
              style: const TextStyle(fontSize: 14, color: AppColors.onSurfaceVariant, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            Row(mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) => const Icon(Icons.star_rounded, color: AppColors.tertiary, size: 28))),
            const SizedBox(height: 12),
            Text('+${_learnedCount * 10} điểm',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.primary)),
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
    final word = widget.topic.words[_currentIndex];
    final appProvider = context.read<AppProvider>();
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
              Text('${_currentIndex + 1}/${widget.topic.words.length}',
                style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              ClipRRect(borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: (_currentIndex + 1) / widget.topic.words.length,
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white), minHeight: 6)),
            ])),
            const SizedBox(width: 16),
            GestureDetector(onTap: () => appProvider.speak(word.english),
              child: Container(width: 44, height: 44,
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.volume_up_rounded, color: Colors.white))),
          ])),
          const SizedBox(height: 16),
          Text(_isFlipped ? 'Nghĩa tiếng Việt' : 'Nhấn để lật thẻ!',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14, fontWeight: FontWeight.w700)),
          const SizedBox(height: 24),
          Expanded(child: GestureDetector(onTap: _flipCard,
            child: AnimatedBuilder(animation: _flipAnimation,
              builder: (ctx, _) {
                double angle = _flipAnimation.value * 3.14159;
                bool showBack = _flipAnimation.value > 0.5;
                return Transform(alignment: Alignment.center,
                  transform: Matrix4.identity()..setEntry(3, 2, 0.001)..rotateY(angle),
                  child: Container(margin: const EdgeInsets.symmetric(horizontal: 32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(
                        color: AppColors.outlineVariant,
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        )
                      ],
                    ),
                    child: Center(child: showBack
                      ? Transform(alignment: Alignment.center, transform: Matrix4.identity()..rotateY(3.14159),
                        child: _buildBackCard(word))
                      : _buildFrontCard(word))));
              }))),
          const SizedBox(height: 24),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              GestureDetector(onTap: _currentIndex > 0 ? () { setState(() { _currentIndex--; _isFlipped = false; }); _flipController.reset(); } : null,
                child: Container(width: 56, height: 56,
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), shape: BoxShape.circle),
                  child: Icon(Icons.arrow_back_rounded, color: _currentIndex > 0 ? Colors.white : Colors.white.withValues(alpha: 0.3), size: 24))),
              GestureDetector(onTap: () => appProvider.speak(word.english),
                child: Container(width: 64, height: 64,
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  child: const Icon(Icons.volume_up_rounded, color: AppColors.primary, size: 28))),
              GestureDetector(onTap: _nextCard,
                child: Container(width: 56, height: 56,
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), shape: BoxShape.circle),
                  child: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 24))),
            ])),
          const SizedBox(height: 32),
        ])),
        Align(alignment: Alignment.topCenter,
          child: ConfettiWidget(confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive, maxBlastForce: 30, minBlastForce: 10, numberOfParticles: 30,
            colors: const [AppColors.primary, AppColors.secondary, AppColors.tertiary])),
      ]));
  }

  Widget _buildFrontCard(VocabularyWord word) {
    return Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(width: 96, height: 96,
        decoration: const BoxDecoration(color: AppColors.primaryFixed, shape: BoxShape.circle),
        child: Center(child: Text(word.emoji, style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold)))),
      const SizedBox(height: 24),
      Text(word.english, textAlign: TextAlign.center, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: AppColors.onSurface, letterSpacing: -0.5)),
      const SizedBox(height: 14),
      Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(color: AppColors.primaryFixed, borderRadius: BorderRadius.circular(16)),
        child: const Text('Nhấn để xem nghĩa', style: TextStyle(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w800))),
    ]));
  }

  Widget _buildBackCard(VocabularyWord word) {
    return Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(width: 80, height: 80,
        decoration: const BoxDecoration(color: AppColors.secondaryContainer, shape: BoxShape.circle),
        child: const Icon(Icons.translate_rounded, color: AppColors.onSecondaryContainer, size: 28)),
      const SizedBox(height: 24),
      Text(word.english, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: AppColors.onSurface)),
      const SizedBox(height: 12),
      Container(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(color: AppColors.secondaryContainer, borderRadius: BorderRadius.circular(16)),
        child: Text(word.vietnamese, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.onSecondaryContainer))),
    ]));
  }
}
