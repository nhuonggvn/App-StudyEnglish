import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/app_provider.dart';
import '../games/game_selection_screen.dart';
import '../games/flashcard/flashcard_game_screen.dart';
import '../games/quiz/quiz_game_screen.dart';
import '../games/matching/matching_game_screen.dart';
import '../games/listening/listening_game_screen.dart';
import '../learning_path/learning_path_screen.dart';
import '../leaderboard/leaderboard_screen.dart';
import '../parent_zone/parent_zone_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    _HomeTab(),
    LearningPathScreen(),
    LeaderboardScreen(),
    ParentZoneScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Stack(
        children: [
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 92), // Chừa khoảng trống cho Custom Bottom Bar
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: _screens[_currentIndex],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildCustomBottomNavBar(),
          ),
        ],
      ),
    );
  }

  // Tái hiện chính xác Bottom Navigation Bar tối giản tuyệt đẹp của người dùng
  Widget _buildCustomBottomNavBar() {
    return Container(
      height: 92,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
        border: const Border(
          top: BorderSide(color: AppColors.outlineVariant, width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavBarItem(0, Icons.map_rounded, 'Map'),
            _buildNavBarItem(1, Icons.menu_book_rounded, 'Learn'),
            _buildNavBarItem(2, Icons.videogame_asset_rounded, 'Games'),
            _buildNavBarItem(3, Icons.supervisor_account_rounded, 'Parents'),
          ],
        ),
      ),
    );
  }

  Widget _buildNavBarItem(int index, IconData icon, String label) {
    bool isActive = _currentIndex == index;

    if (isActive) {
      // Tab active: có màu bg-secondary-container, border bottom dày 4px
      return GestureDetector(
        onTap: () {
          setState(() {
            _currentIndex = index;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.secondaryContainer,
            borderRadius: BorderRadius.circular(16),
            border: const Border(
              bottom: BorderSide(
                color: AppColors.onSecondaryFixedVariant,
                width: 4,
              ),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: AppColors.onSecondaryContainer,
                size: 22,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.onSecondaryContainer,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Tab inactive: chữ màu outline xám, nhấn nhẹ
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: AppColors.outline,
              size: 24,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.outline,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();

    return Container(
      color: AppColors.backgroundLight,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top App Bar
              _buildTopAppBar(context, appProvider),
              const SizedBox(height: 28),

              // Welcome Hero
              _buildWelcomeHero(appProvider),
              const SizedBox(height: 28),

              // Stats Row
              _buildStatsRow(appProvider),
              const SizedBox(height: 28),

              // Games Title
              const Text(
                'Chế độ chơi',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 14),
              _buildGamesGrid(context, appProvider),

              const SizedBox(height: 28),

              // Topics Title
              const Text(
                'Chủ đề từ vựng',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 14),
              _buildTopicsGrid(context, appProvider),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopAppBar(BuildContext context, AppProvider appProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primaryFixed,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary, width: 2),
              ),
              child: Center(
                child: Text(
                  appProvider.avatarEmoji.isNotEmpty
                      ? appProvider.avatarEmoji
                      : 'TH',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'LingoKids',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        // Settings/Status Button
        Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.settings_rounded, size: 20, color: AppColors.onSurfaceVariant),
            onPressed: () {
              // Action setting
            },
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeHero(AppProvider appProvider) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.15),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Chào bé, ${appProvider.userName.isNotEmpty ? appProvider.userName : 'Tùng'}!',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Sẵn sàng khám phá tiếng Anh chưa?',
                style: TextStyle(
                  color: AppColors.primaryFixed,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Positioned(
            right: -10,
            bottom: -10,
            child: Opacity(
              opacity: 0.15,
              child: Icon(
                Icons.auto_stories_rounded,
                size: 80,
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(AppProvider appProvider) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.star_rounded,
            value: '${appProvider.totalScore}',
            label: 'Điểm số',
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.menu_book_rounded,
            value: '${appProvider.learnedWordsCount}',
            label: 'Từ đã học',
            color: AppColors.secondary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.local_fire_department_rounded,
            value: '${appProvider.streakDays} ngày',
            label: 'Chuỗi học',
            color: AppColors.tertiary,
          ),
        ),
      ],
    );
  }

  Widget _buildGamesGrid(BuildContext context, AppProvider appProvider) {
    // Mỗi game có màu riêng và route trực tiếp vào màn hình game tương ứng
    final games = [
      {
        'title': 'Flashcard',
        'icon': Icons.style_rounded,
        'cardBg': const Color(0xFFEADDFF),
        'iconColor': const Color(0xFF6B38D4),
        'titleColor': const Color(0xFF21005D),
        'type': 'flashcard',
      },
      {
        'title': 'Trắc nghiệm',
        'icon': Icons.quiz_rounded,
        'cardBg': const Color(0xFFB3EFDA),
        'iconColor': const Color(0xFF006C49),
        'titleColor': const Color(0xFF002117),
        'type': 'quiz',
      },
      {
        'title': 'Ghép hình',
        'icon': Icons.extension_rounded,
        'cardBg': const Color(0xFFFFDEBB),
        'iconColor': const Color(0xFF7D4E00),
        'titleColor': const Color(0xFF281900),
        'type': 'matching',
      },
      {
        'title': 'Nghe & Chọn',
        'icon': Icons.headphones_rounded,
        'cardBg': const Color(0xFFD3E4FF),
        'iconColor': const Color(0xFF2B5FAB),
        'titleColor': const Color(0xFF001C40),
        'type': 'listening',
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.0,
      ),
      itemCount: games.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            final topics = appProvider.currentTopics;
            if (topics.isNotEmpty) {
              // Lấy chủ đề đầu tiên và điều hướng thẳng vào game tương ứng
              final topic = topics[0];
              final gameType = games[index]['type'] as String;
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
          },
          child: Container(
            decoration: BoxDecoration(
              color: games[index]['cardBg'] as Color,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  games[index]['icon'] as IconData,
                  color: games[index]['iconColor'] as Color,
                  size: 48,
                ),
                const SizedBox(height: 10),
                Text(
                  games[index]['title'] as String,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: games[index]['titleColor'] as Color,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTopicsGrid(BuildContext context, AppProvider appProvider) {
    final topics = appProvider.currentTopics;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.9,
      ),
      itemCount: topics.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => GameSelectionScreen(topic: topics[index]),
              ),
            );
          },
          child: Container(
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
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryFixed,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      topics[index].emoji,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    topics[index].name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: AppColors.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.outlineVariant,
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
