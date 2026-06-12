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
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.outlineVariant,
                          width: 1.5,
                        ),
                      ),
                      child: const Icon(
                        Icons.arrow_back_rounded,
                        color: AppColors.onSurface,
                        size: 20,
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
                            color: AppColors.onSurface,
                            letterSpacing: -0.5,
                          ),
                        ),
                        Text(
                          '${topic.words.length} từ vựng học tập',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryFixed,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        topic.emoji,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Game cards list
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  _GameOptionCard(
                    title: 'Flashcard',
                    description: 'Lật thẻ để học từ vựng trực quan sinh động',
                    icon: Icons.style_rounded,
                    iconBg: AppColors.primaryFixed,
                    iconColor: AppColors.primary,
                    onTap: () => _navigateToGame(context, 'flashcard'),
                  ),
                  const SizedBox(height: 14),
                  _GameOptionCard(
                    title: 'Trắc nghiệm',
                    description: 'Trả lời nhanh để củng cố phản xạ nghĩa của từ',
                    icon: Icons.quiz_rounded,
                    iconBg: AppColors.secondaryContainer,
                    iconColor: AppColors.secondary,
                    onTap: () => _navigateToGame(context, 'quiz'),
                  ),
                  const SizedBox(height: 14),
                  _GameOptionCard(
                    title: 'Ghép hình',
                    description: 'Ghép nối từ tiếng Anh tương ứng với ảnh minh họa',
                    icon: Icons.extension_rounded,
                    iconBg: AppColors.tertiaryFixed,
                    iconColor: AppColors.tertiary,
                    onTap: () => _navigateToGame(context, 'matching'),
                  ),
                  const SizedBox(height: 14),
                  _GameOptionCard(
                    title: 'Nghe & Chọn',
                    description: 'Nghe phát âm chuẩn bản ngữ và chọn thẻ đáp án',
                    icon: Icons.headphones_rounded,
                    iconBg: AppColors.primaryFixed,
                    iconColor: AppColors.primaryContainer,
                    onTap: () => _navigateToGame(context, 'listening'),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
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
  final Color iconBg;
  final Color iconColor;
  final VoidCallback onTap;

  const _GameOptionCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
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
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: AppColors.outlineVariant,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: widget.iconBg,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  widget.icon,
                  color: widget.iconColor,
                  size: 22,
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
                        color: AppColors.onSurface,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.description,
                      style: const TextStyle(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppColors.outline,
                size: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
