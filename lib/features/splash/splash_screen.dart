import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/app_provider.dart';
import '../onboarding/onboarding_screen.dart';
import '../home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _bubbleController;
  late Animation<double> _logoScale;
  late Animation<double> _logoRotation;
  late Animation<double> _textOpacity;
  late Animation<Offset> _textSlide;
  late Animation<double> _bubbleAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _navigateToNextScreen();
  }

  void _setupAnimations() {
    // Logo animation
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );
    _logoRotation = Tween<double>(begin: -0.5, end: 0.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    // Text animation
    _textController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeIn),
    );
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOutBack),
    );

    // Bubble animation
    _bubbleController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
    _bubbleAnimation = Tween<double>(begin: 0, end: 1).animate(_bubbleController);

    // Start animations sequence
    _logoController.forward().then((_) {
      _textController.forward();
    });
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    final appProvider = context.read<AppProvider>();

    Widget nextScreen;
    if (appProvider.onboardingComplete) {
      nextScreen = const HomeScreen();
    } else {
      nextScreen = const OnboardingScreen();
    }

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => nextScreen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _bubbleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.splashGradient,
        ),
        child: Stack(
          children: [
            // Animated bubbles background
            ...List.generate(12, (index) {
              return AnimatedBuilder(
                animation: _bubbleAnimation,
                builder: (context, child) {
                  double progress = (_bubbleAnimation.value + index * 0.08) % 1.0;
                  double x = (index % 4) * (MediaQuery.of(context).size.width / 4) +
                      20 +
                      (index * 17 % 30);
                  double startY = MediaQuery.of(context).size.height + 50;
                  double endY = -100.0;
                  double y = startY + (endY - startY) * progress;
                  double opacity = progress < 0.3
                      ? progress / 0.3
                      : progress > 0.7
                          ? (1.0 - progress) / 0.3
                          : 1.0;
                  double size = 20.0 + (index % 5) * 10;

                  return Positioned(
                    left: x,
                    top: y,
                    child: Opacity(
                      opacity: opacity * 0.2,
                      child: Container(
                        width: size,
                        height: size,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                      ),
                    ),
                  );
                },
              );
            }),

            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  AnimatedBuilder(
                    animation: _logoController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _logoScale.value,
                        child: Transform.rotate(
                          angle: _logoRotation.value,
                          child: Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Text(
                                'LK',
                                style: TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.primary,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 32),

                  // App name
                  SlideTransition(
                    position: _textSlide,
                    child: FadeTransition(
                      opacity: _textOpacity,
                      child: Column(
                        children: [
                          const Text(
                            'LingoKids',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 1.5,
                              shadows: [
                                Shadow(
                                  color: Colors.black12,
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Học tiếng Anh vui vẻ cùng bé!',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.white.withValues(alpha: 0.9),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 60),

                  // Loading indicator
                  FadeTransition(
                    opacity: _textOpacity,
                    child: SizedBox(
                      width: 36,
                      height: 36,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
