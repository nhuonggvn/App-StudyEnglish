import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/models.dart';
import 'flashcard/flashcard_game_screen.dart';
import 'quiz/quiz_game_screen.dart';
import 'matching/matching_game_screen.dart';
import 'listening/listening_game_screen.dart';

class GameSelectionScreen extends StatelessWidget {
  final TopicData topic;

  const GameSelectionScreen({
    super.key,
    required this.topic,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8F9FF), Color(0xFFEEF0FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.06),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.arrow_back_rounded,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            topic.name,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            '${topic.words.length} tu vung',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primaryPurple.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        topic.emoji,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryPurple,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Game cards
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _GameOptionCard(
                      title: 'Flashcard',
                      description: 'Lat the de hoc tu vung voi phat am chuan',
                      icon: Icons.style_rounded,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6C5CE7), Color(0xFFA29BFE)],
                      ),
                      onTap: () => _navigateToGame(context, 'flashcard'),
                    ),
                    const SizedBox(height: 14),
                    _GameOptionCard(
                      title: 'Trac nghiem',
                      description: 'Tra loi nhanh de kiem tra tu vung',
                      icon: Icons.quiz_rounded,
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF7675), Color(0xFFFD79A8)],
                      ),
                      onTap: () => _navigateToGame(context, 'quiz'),
                    ),
                    const SizedBox(height: 14),
                    _GameOptionCard(
                      title: 'Ghep hinh',
                      description: 'Ghep tu tieng Anh voi nghia tieng Viet',
                      icon: Icons.extension_rounded,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF00B894), Color(0xFF55EFC4)],
                      ),
                      onTap: () => _navigateToGame(context, 'matching'),
                    ),
                    const SizedBox(height: 14),
                    _GameOptionCard(
                      title: 'Nghe & Chon',
                      description: 'Nghe phat am va chon dap an dung',
                      icon: Icons.headphones_rounded,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0984E3), Color(0xFF74B9FF)],
                      ),
                      onTap: () => _navigateToGame(context, 'listening'),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToGame(BuildContext context, String gameType) {
    Widget gameScreen;
    switch (gameType) {
      case 'flashcard':
        gameScreen = FlashcardGameScreen(topic: topic);
        break;
      case 'quiz':
        gameScreen = QuizGameScreen(topic: topic);
        break;
      case 'matching':
        gameScreen = MatchingGameScreen(topic: topic);
        break;
      case 'listening':
        gameScreen = ListeningGameScreen(topic: topic);
        break;
      default:
        gameScreen = FlashcardGameScreen(topic: topic);
    }

    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => gameScreen),
    );
  }
}

class _GameOptionCard extends StatefulWidget {
  final String title;
  final String description;
  final IconData icon;
  final LinearGradient gradient;
  final VoidCallback onTap;

  const _GameOptionCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.gradient,
    required this.onTap,
  });

  @override
  State<_GameOptionCard> createState() => _GameOptionCardState();
}

class _GameOptionCardState extends State<_GameOptionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: widget.gradient,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: widget.gradient.colors.first.withValues(alpha: 0.35),
                blurRadius: 14,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(
                  widget.icon,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.description,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white.withValues(alpha: 0.7),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
