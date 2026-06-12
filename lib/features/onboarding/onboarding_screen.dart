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
      'title': 'Chao mung den voi\nKidEnglish!',
      'desc': 'Cung hoc tieng Anh qua nhung tro choi thu vi nhe!',
      'emoji': 'KE',
    },
    {
      'title': 'Hoc ma choi\nChoi ma hoc',
      'desc': 'Nhieu tro choi hap dan giup con hoc nhanh hon!',
      'emoji': 'GM',
    },
    {
      'title': 'Theo doi\ntien do',
      'desc': 'Ba me co the theo doi qua trinh hoc cua con!',
      'emoji': 'RP',
    },
  ];

  // Profile setup
  final TextEditingController _nameController = TextEditingController();
  int _selectedAgeGroup = -1;
  String _selectedAvatar = '';
  bool _showProfileSetup = false;

  final List<String> _avatarOptions = [
    'TH', // Tho
    'ME', // Meo
    'CU', // Cuu
    'GA', // Gau
    'SU', // Su tu
    'VO', // Voi
    'KH', // Khi
    'CH', // Chim
  ];

  // Đổi thành một danh sách màu xanh dịu phối hợp tinh tế
  final List<Color> _avatarColors = [
    AppColors.primaryGreen,
    const Color(0xFF2E8B57),
    const Color(0xFF156E3D),
    const Color(0xFF3CB371),
    AppColors.primaryGreen,
    const Color(0xFF2E8B57),
    const Color(0xFF156E3D),
    const Color(0xFF3CB371),
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
          content: const Text('Hay nhap ten cua con nhe!'),
          backgroundColor: AppColors.primaryGreen,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    if (_selectedAgeGroup == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Hay chon do tuoi nhe!'),
          backgroundColor: AppColors.primaryGreen,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
        pageBuilder: (context, animation, secondaryAnimation) =>
            const HomeScreen(),
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
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _showProfileSetup = true;
                    });
                  },
                  child: const Text(
                    'Bo qua',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
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
                    width: _currentPage == index ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? AppColors.primaryGreen
                          : AppColors.primaryGreen.withValues(alpha: 0.2),
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
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _nextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      _currentPage == _pages.length - 1
                          ? 'Bat dau nao!'
                          : 'Tiep theo',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
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
          // Illustration container
          Container(
            width: 180,
            height: 180,
            decoration: const BoxDecoration(
              color: AppColors.softGreenTint,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                emoji,
                style: const TextStyle(
                  fontSize: 56,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryGreen,
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
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              height: 1.25,
            ),
          ),

          const SizedBox(height: 12),

          // Description
          Text(
            desc,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSetup() {
    return Scaffold(
      body: Container(
        color: AppColors.backgroundLight,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),

                // Title
                const Center(
                  child: Text(
                    'Thiet lap ho so',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),

                const SizedBox(height: 6),
                const Center(
                  child: Text(
                    'Hay cho chung toi biet ve con nhe!',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // Avatar selection
                const Text(
                  'Chon hinh dai dien:',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
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
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? _avatarColors[index]
                              : _avatarColors[index].withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? _avatarColors[index]
                                : Colors.transparent,
                            width: 2.5,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            _avatarOptions[index],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color:
                                  isSelected ? Colors.white : _avatarColors[index],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 28),

                // Name input
                const Text(
                  'Ten cua con:',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _nameController,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Nhap ten con...',
                    hintStyle: const TextStyle(
                      color: AppColors.textHint,
                      fontSize: 14,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppColors.primaryGreen.withValues(alpha: 0.15),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppColors.primaryGreen,
                        width: 1.5,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    prefixIcon: const Icon(
                      Icons.person_outline_rounded,
                      color: AppColors.primaryGreen,
                      size: 20,
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // Age group selection
                const Text(
                  'Con bao nhieu tuoi?',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                ..._buildAgeGroupCards(),

                const SizedBox(height: 32),

                // Continue button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _completeSetup,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Bat dau hoc nao!',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildAgeGroupCards() {
    final ageGroups = [
      {
        'label': '3-5 tuoi',
        'desc': 'Mam non',
        'color': AppColors.primaryGreen,
        'icon': Icons.child_care_rounded,
      },
      {
        'label': '6-7 tuoi',
        'desc': 'Lop 1-2',
        'color': AppColors.primaryGreen,
        'icon': Icons.school_rounded,
      },
      {
        'label': '8-10 tuoi',
        'desc': 'Lop 3-5',
        'color': AppColors.primaryGreen,
        'icon': Icons.auto_stories_rounded,
      },
    ];

    return List.generate(ageGroups.length, (index) {
      bool isSelected = _selectedAgeGroup == index;
      Color cardColor = ageGroups[index]['color'] as Color;

      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: GestureDetector(
          onTap: () {
            setState(() {
              _selectedAgeGroup = index;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isSelected ? cardColor : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? cardColor : cardColor.withValues(alpha: 0.15),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.01),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
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
                        : AppColors.softGreenTint,
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
                        fontWeight: FontWeight.w700,
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      ageGroups[index]['desc'] as String,
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected
                            ? Colors.white.withValues(alpha: 0.8)
                            : AppColors.textSecondary,
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
