import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/models.dart';
import 'flashcard/flashcard_game_screen.dart';
import 'quiz/quiz_game_screen.dart';
import 'matching/matching_game_screen.dart';
import 'listening/listening_game_screen.dart';

// Dữ liệu cấu hình cho từng chế độ chơi
class _GameMode {
  final String id;
  final String title;
  final IconData icon;
  final Color cardBg;       // Màu nền đặc trưng của thẻ
  final Color iconColor;    // Màu icon
  final Color titleColor;   // Màu chữ tiêu đề

  const _GameMode({
    required this.id,
    required this.title,
    required this.icon,
    required this.cardBg,
    required this.iconColor,
    required this.titleColor,
  });
}

// Danh sách 4 chế độ chơi với màu sắc riêng biệt
const List<_GameMode> _gameModes = [
  _GameMode(
    id: 'flashcard',
    title: 'Flashcard',
    icon: Icons.style_rounded,
    cardBg: Color(0xFFEADDFF),   // Tím nhạt (primaryFixed)
    iconColor: Color(0xFF6B38D4), // Tím đậm (primary)
    titleColor: Color(0xFF21005D),
  ),
  _GameMode(
    id: 'quiz',
    title: 'Trắc nghiệm',
    icon: Icons.quiz_rounded,
    cardBg: Color(0xFFB3EFDA),   // Xanh mint nhạt
    iconColor: Color(0xFF006C49), // Xanh lá đậm (secondary)
    titleColor: Color(0xFF002117),
  ),
  _GameMode(
    id: 'matching',
    title: 'Ghép hình',
    icon: Icons.extension_rounded,
    cardBg: Color(0xFFFFDEBB),   // Cam đào nhạt (tertiaryFixed)
    iconColor: Color(0xFF7D4E00), // Cam nâu đậm (tertiary)
    titleColor: Color(0xFF281900),
  ),
  _GameMode(
    id: 'listening',
    title: 'Nghe & Chọn',
    icon: Icons.headphones_rounded,
    cardBg: Color(0xFFD3E4FF),   // Xanh dương nhạt (primaryContainer)
    iconColor: Color(0xFF2B5FAB), // Xanh dương đậm
    titleColor: Color(0xFF001C40),
  ),
];

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
          crossAxisAlignment: CrossAxisAlignment.start,
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
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Tiêu đề hướng dẫn
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Chọn chế độ chơi',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Lưới 2 cột các chế độ chơi
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 1.0,
                  children: _gameModes.map((mode) {
                    return _GameModeCard(
                      mode: mode,
                      onTap: () => _navigateToGame(context, mode.id),
                    );
                  }).toList(),
                ),
              ),
            ),

            const SizedBox(height: 24),
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

// Widget thẻ chế độ chơi dạng ô vuông với màu nền riêng
class _GameModeCard extends StatefulWidget {
  final _GameMode mode;
  final VoidCallback onTap;

  const _GameModeCard({
    required this.mode,
    required this.onTap,
  });

  @override
  State<_GameModeCard> createState() => _GameModeCardState();
}

class _GameModeCardState extends State<_GameModeCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.93).animate(
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
          decoration: BoxDecoration(
            // Màu nền đặc trưng riêng của từng chế độ
            color: widget.mode.cardBg,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon lớn ở giữa thẻ
              Icon(
                widget.mode.icon,
                color: widget.mode.iconColor,
                size: 52,
              ),
              const SizedBox(height: 12),
              // Tên chế độ chơi — không có chữ mô tả phía dưới
              Text(
                widget.mode.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: widget.mode.titleColor,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
