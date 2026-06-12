import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/app_provider.dart';
import '../home/home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Onboarding data
  final List<Map<String, String>> _pages = [
    {
      'title': 'Chào mừng đến với\nLingoKids!',
      'desc': 'Cùng học tiếng Anh qua những trò chơi thú vị nhé!',
      'emoji': 'LK',
    },
    {
      'title': 'Học mà chơi\nChơi mà học',
      'desc': 'Nhiều trò chơi hấp dẫn giúp con học nhanh hơn!',
      'emoji': '🎮',
    },
    {
      'title': 'Theo dõi\ntiến độ',
      'desc': 'Ba mẹ có thể theo dõi quá trình học tập của con!',
      'emoji': '📊',
    },
  ];

  // Profile setup
  final TextEditingController _nameController = TextEditingController();
  int _selectedAgeGroup = -1;
  String _selectedAvatar = '';
  bool _showProfileSetup = false;

  // Sử dụng các con vật siêu đáng yêu để các bé lựa chọn thay vì chữ viết tắt
  final List<String> _avatarOptions = [
    '🦁', // Sư tử
    '🐼', // Gấu trúc
    '🦊', // Cáo
    '🐰', // Thỏ
    '🐨', // Koala
    '🐯', // Hổ
    '🐸', // Ếch
    '🐵', // Khỉ
  ];

  // Danh sách màu pastel phối hợp nhẹ nhàng tương ứng với mỗi avatar
  final List<Color> _avatarColors = [
    const Color(0xFFFFE0B2), // Cam nhạt cho Sư tử
    const Color(0xFFECEFF1), // Xám nhạt cho Gấu trúc
    const Color(0xFFFFCC80), // Cam sậm cho Cáo
    const Color(0xFFF8BBD0), // Hồng nhạt cho Thỏ
    const Color(0xFFD7CCC8), // Nâu nhạt cho Koala
    const Color(0xFFFFE0B2), // Cam cho Hổ
    const Color(0xFFC8E6C9), // Xanh lá nhạt cho Ếch
    const Color(0xFFD7CCC8), // Nâu cho Khỉ
  ];

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      setState(() {
        _showProfileSetup = true;
      });
    }
  }

  Future<void> _completeSetup() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Hãy nhập tên của con nhé!'),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      );
      return;
    }

    if (_selectedAgeGroup == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Hãy chọn độ tuổi nhé!'),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      );
      return;
    }

    final appProvider = context.read<AppProvider>();
    await appProvider.completeOnboarding(
      name: _nameController.text.trim(),
      ageGroup: _selectedAgeGroup,
      avatarEmoji: _selectedAvatar.isEmpty ? _avatarOptions[0] : _selectedAvatar,
    );

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const HomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_showProfileSetup) {
      return _buildProfileSetup();
    }
    return _buildOnboardingPages();
  }

  Widget _buildOnboardingPages() {
    return Scaffold(
      body: Container(
        color: AppColors.backgroundLight,
        child: SafeArea(
          child: Column(
            children: [
              // Skip button
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _showProfileSetup = true;
                      });
                    },
                    child: const Text(
                      'Bỏ qua',
                      style: TextStyle(
                        color: AppColors.outline,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),

              // Pages
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    return _buildPage(
                      _pages[index]['title']!,
                      _pages[index]['desc']!,
                      _pages[index]['emoji']!,
                      index,
                    );
                  },
                ),
              ),

              // Page indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_pages.length, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 28 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? AppColors.primary
                          : AppColors.primary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 32),

              // Next button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _nextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: Text(
                      _currentPage == _pages.length - 1 ? 'Bắt đầu nào!' : 'Tiếp theo',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage(String title, String desc, String emoji, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration container - Đổi sang màu tím nhẹ thương hiệu
          Container(
            width: 180,
            height: 180,
            decoration: const BoxDecoration(
              color: Color(0xFFF3EDF7), // Tím nhạt nhẽo của thiết kế mới
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                emoji,
                style: TextStyle(
                  fontSize: emoji.length > 2 ? 42 : 56,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),

          const SizedBox(height: 40),

          // Title
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: AppColors.onSurface,
              letterSpacing: -0.5,
              height: 1.2,
            ),
          ),

          const SizedBox(height: 16),

          // Description
          Text(
            desc,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              color: AppColors.outline,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSetup() {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              // Title
              const Center(
                child: Text(
                  'Thiết lập hồ sơ',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: AppColors.onSurface,
                    letterSpacing: -0.5,
                  ),
                ),
              ),

              const SizedBox(height: 6),
              const Center(
                child: Text(
                  'Hãy cho chúng tôi biết về con nhé!',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.outline,
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // Avatar selection
              const Text(
                'Chọn hình đại diện:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: List.generate(_avatarOptions.length, (index) {
                    bool isSelected = _selectedAvatar == _avatarOptions[index];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedAvatar = _avatarOptions[index];
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : _avatarColors[index],
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? AppColors.primary : Colors.transparent,
                            width: 2.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: isSelected ? 0.2 : 0.02),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child: Center(
                          child: Text(
                            _avatarOptions[index],
                            style: const TextStyle(
                              fontSize: 28,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),

              const SizedBox(height: 28),

              // Name input
              const Text(
                'Tên của con:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _nameController,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurface,
                ),
                decoration: InputDecoration(
                  hintText: 'Nhập tên con...',
                  hintStyle: const TextStyle(
                    color: AppColors.outline,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: AppColors.outlineVariant,
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  prefixIcon: const Icon(
                    Icons.person_outline_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // Age group selection
              const Text(
                'Con bao nhiêu tuổi?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              ..._buildAgeGroupCards(),

              const SizedBox(height: 32),

              // Continue button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _completeSetup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: const Text(
                    'Bắt đầu học nào!',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildAgeGroupCards() {
    final ageGroups = [
      {
        'label': '3-5 tuổi',
        'desc': 'Mầm non',
        'color': AppColors.primary,
        'icon': Icons.child_care_rounded,
      },
      {
        'label': '6-7 tuổi',
        'desc': 'Lớp 1-2',
        'color': AppColors.primary,
        'icon': Icons.school_rounded,
      },
      {
        'label': '8-10 tuổi',
        'desc': 'Lớp 3-5',
        'color': AppColors.primary,
        'icon': Icons.auto_stories_rounded,
      },
    ];

    return List.generate(ageGroups.length, (index) {
      bool isSelected = _selectedAgeGroup == index;
      Color cardColor = ageGroups[index]['color'] as Color;

      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: GestureDetector(
          onTap: () {
            setState(() {
              _selectedAgeGroup = index;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected ? cardColor : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? cardColor : AppColors.outlineVariant,
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: isSelected ? 0.08 : 0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white.withValues(alpha: 0.2)
                        : const Color(0xFFF3EDF7), // Tím nhạt nhẽo chuẩn Bento
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    ageGroups[index]['icon'] as IconData,
                    color: isSelected ? Colors.white : cardColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ageGroups[index]['label'] as String,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: isSelected ? Colors.white : AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      ageGroups[index]['desc'] as String,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? Colors.white.withValues(alpha: 0.8)
                            : AppColors.outline,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                if (isSelected)
                  Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_rounded,
                      color: cardColor,
                      size: 16,
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
