import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class GradientButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final LinearGradient? gradient;
  final double? width;
  final double height;
  final double borderRadius;
  final double fontSize;
  final IconData? icon;
  final Color backgroundColor;
  final Color borderBottomColor;

  const GradientButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.gradient,
    this.width,
    this.height = 56,
    this.borderRadius = 16,
    this.fontSize = 16,
    this.icon,
    this.backgroundColor = AppColors.primary,
    this.borderBottomColor = const Color(0xFF5516BE), // Tím thẫm hơn
  });

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    // Nút dạng Pushable Button 3D phẳng của Tailwind mockup:
    // border-b-[4px] border-on-primary-fixed-variant
    // active:translate-y-[2px] active:border-b-0
    final double currentBorderBottom = _isPressed ? 0.0 : 4.0;
    final double topMargin = _isPressed ? 4.0 : 0.0;
    final double bottomMargin = _isPressed ? 0.0 : 4.0;

    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _isPressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          _isPressed = false;
        });
        widget.onPressed();
      },
      onTapCancel: () {
        setState(() {
          _isPressed = false;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 60),
        margin: EdgeInsets.only(top: topMargin, bottom: bottomMargin),
        width: widget.width,
        height: widget.height - 4,
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          border: Border(
            bottom: BorderSide(
              color: widget.borderBottomColor,
              width: currentBorderBottom,
            ),
          ),
          boxShadow: _isPressed
              ? []
              : [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[
                Icon(
                  widget.icon,
                  color: Colors.white,
                  size: widget.fontSize + 4,
                ),
                const SizedBox(width: 8),
              ],
              Text(
                widget.text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: widget.fontSize,
                  fontWeight: FontWeight.w800, // Đậm hơn giống mockup
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BounceWidget extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Duration duration;

  const BounceWidget({
    super.key,
    required this.child,
    this.onTap,
    this.duration = const Duration(milliseconds: 200),
  });

  @override
  State<BounceWidget> createState() => _BounceWidgetState();
}

class _BounceWidgetState extends State<BounceWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
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

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onTap?.call();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: ScaleTransition(
        scale: _scale,
        child: widget.child,
      ),
    );
  }
}

class GameCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String emoji;
  final LinearGradient gradient;
  final VoidCallback onTap;

  const GameCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Áp dụng thiết kế Bento Grid: bo góc 32px, shadow nhẹ và viền nhạt
    return BounceWidget(
      onTap: onTap,
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
              color: AppColors.primary.withValues(alpha: 0.06),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: AppColors.primaryFixed,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  emoji,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StarRating extends StatelessWidget {
  final int stars;
  final int maxStars;
  final double size;

  const StarRating({
    super.key,
    required this.stars,
    this.maxStars = 3,
    this.size = 28,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxStars, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Icon(
            index < stars ? Icons.star_rounded : Icons.star_outline_rounded,
            color: index < stars ? AppColors.starGold : AppColors.outlineVariant,
            size: size,
          ),
        );
      }),
    );
  }
}

class TopicCard extends StatelessWidget {
  final String name;
  final String emoji;
  final Color color;
  final double progress;
  final bool isLocked;
  final VoidCallback onTap;

  const TopicCard({
    super.key,
    required this.name,
    required this.emoji,
    required this.color,
    required this.progress,
    required this.isLocked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Giao diện thẻ chủ đề bento bo góc 32px
    return BounceWidget(
      onTap: isLocked ? null : onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isLocked
              ? AppColors.surfaceContainerLow
              : AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: isLocked 
                ? AppColors.outlineVariant.withValues(alpha: 0.5) 
                : AppColors.outlineVariant,
            width: 1.5,
          ),
          boxShadow: isLocked
              ? []
              : [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isLocked
                    ? AppColors.surfaceContainerHighest
                    : AppColors.primaryFixed,
                shape: BoxShape.circle,
              ),
              child: isLocked
                  ? const Icon(
                      Icons.lock_rounded,
                      size: 22,
                      color: AppColors.outline,
                    )
                  : Text(
                      emoji,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
            const SizedBox(height: 10),
            Text(
              name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: isLocked ? AppColors.outline : AppColors.textPrimary,
              ),
            ),
            if (!isLocked) ...[
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: AppColors.surfaceContainerHigh,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.secondary),
                  minHeight: 4,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
