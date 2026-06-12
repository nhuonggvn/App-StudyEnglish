import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/app_provider.dart';
import '../games/game_selection_screen.dart';

class LearningPathScreen extends StatelessWidget {
  const LearningPathScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();
    final topics = appProvider.currentTopics;
    final pathItems = appProvider.learningPath;

    return Container(
      color: AppColors.backgroundLight,
      child: SafeArea(
        child: Column(
          children: [
            // Top Header
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Hành trình học',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: AppColors.onSurface,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryFixed,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      appProvider.ageGroupLabel,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Learning Path List
            Expanded(
              child: Stack(
                children: [
                  // Đường nối nét chấm đứt chạy dọc chính giữa màn hình
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 4,
                      color: AppColors.outlineVariant.withValues(alpha: 0.5),
                    ),
                  ),
                  ListView.builder(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                    itemCount: pathItems.length,
                    itemBuilder: (context, index) {
                      final item = pathItems[index];
                      final topic = index < topics.length ? topics[index] : null;

                      // Quyết định căn lề so le (lệch trái, lệch phải, ở giữa)
                      Alignment cardAlignment;
                      if (index % 3 == 0) {
                        cardAlignment = Alignment.centerLeft;
                      } else if (index % 3 == 1) {
                        cardAlignment = Alignment.centerRight;
                      } else {
                        cardAlignment = Alignment.center;
                      }

                      return Align(
                        alignment: cardAlignment,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.78,
                          margin: const EdgeInsets.symmetric(vertical: 16),
                          child: _buildPathCard(context, item, topic, index),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPathCard(BuildContext context, dynamic item, dynamic topic, int index) {
    bool isLocked = item.isLocked;
    bool isCompleted = item.isCompleted;

    // Giao diện thẻ bento bo góc 32px
    return Container(
      decoration: BoxDecoration(
        color: isLocked ? AppColors.surfaceContainerLow : AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: isLocked ? AppColors.outlineVariant.withValues(alpha: 0.5) : AppColors.outlineVariant,
          width: 1.5,
        ),
        boxShadow: isLocked
            ? []
            : [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.05),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: isLocked
                            ? AppColors.surfaceContainerHighest
                            : isCompleted
                                ? AppColors.secondaryContainer
                                : AppColors.primaryFixed,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: isLocked
                            ? const Icon(
                                Icons.lock_rounded,
                                color: AppColors.outline,
                                size: 24,
                              )
                            : isCompleted
                                ? const Icon(
                                    Icons.star_rounded,
                                    color: AppColors.onSecondaryContainer,
                                    size: 28,
                                  )
                                : Text(
                                    item.emoji,
                                    style: const TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.topicName,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: isLocked ? AppColors.outline : AppColors.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: isLocked
                                  ? AppColors.surfaceContainerHighest
                                  : AppColors.secondaryContainer,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              isLocked ? 'Khóa' : 'Dễ',
                              style: TextStyle(
                                color: isLocked ? AppColors.outline : AppColors.onSecondaryContainer,
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (!isLocked) ...[
                  // Progress Bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: item.progress,
                      minHeight: 10,
                      backgroundColor: AppColors.surfaceContainerHigh,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.secondary),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${(item.progress * 100).round()}% Hoàn thành',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        '${item.completedLessons}/${item.totalLessons} bài',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.outline,
                        ),
                      ),
                    ],
                  ),
                ],
                // Hiển thị nút "Bắt đầu ngay" cho bài học active chưa hoàn thành (index % 3 == 1)
                if (!isLocked && index % 3 == 1 && topic != null) ...[
                  const SizedBox(height: 16),
                  _buildStartButton(context, topic),
                ],
              ],
            ),
          ),
          // Ổ khóa xoay nghiêng mờ ở góc
          if (isLocked)
            Positioned(
              right: -10,
              top: -10,
              child: Transform.rotate(
                angle: 12 * math.pi / 180,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.outlineVariant, width: 1.5),
                  ),
                  child: const Icon(
                    Icons.lock_outline_rounded,
                    color: AppColors.outline,
                    size: 18,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStartButton(BuildContext context, dynamic topic) {
    // Tái tạo nút bấm pushable: py-4 bg-primary text-on-primary
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => GameSelectionScreen(topic: topic),
          ),
        );
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
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Center(
          child: Text(
            'Bắt đầu ngay',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}
