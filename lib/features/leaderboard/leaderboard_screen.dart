import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/app_provider.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();
    final leaderboard = appProvider.leaderboard;

    return Container(
      color: AppColors.backgroundLight,
      child: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Bảng xếp hạng',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.onSurface,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
            ),

            // Top 3 podium
            if (leaderboard.length >= 3) _buildPodium(leaderboard),
            const SizedBox(height: 20),

            // Rest of leaderboard
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
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
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: leaderboard.length > 3 ? leaderboard.length - 3 : 0,
                    itemBuilder: (ctx, index) {
                      final entry = leaderboard[index + 3];
                      bool isCurrentUser = entry.name == appProvider.userName;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: isCurrentUser
                              ? AppColors.primaryFixed
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                          border: isCurrentUser
                              ? Border.all(
                                  color: AppColors.primary.withValues(alpha: 0.2),
                                  width: 1.5,
                                )
                              : null,
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 32,
                              child: Text(
                                '${entry.rank}',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: isCurrentUser
                                      ? AppColors.primary
                                      : AppColors.outline,
                                ),
                              ),
                            ),
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: isCurrentUser
                                    ? Colors.white
                                    : AppColors.surfaceContainerLow,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  entry.avatarEmoji,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isCurrentUser ? '${entry.name} (Bạn)' : entry.name,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                      color: isCurrentUser
                                          ? AppColors.primary
                                          : AppColors.onSurface,
                                    ),
                                  ),
                                  Text(
                                    '${entry.streakDays} ngày liên tiếp',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '${entry.totalScore}',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: isCurrentUser
                                    ? AppColors.primary
                                    : AppColors.onSurface,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.star_rounded,
                                color: AppColors.tertiary, size: 16),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPodium(List leaderboard) {
    // Top 1: Tím primary, Top 2: Xanh secondary, Top 3: Cam/Nâu tertiary
    final colors = [
      AppColors.secondary,
      AppColors.primary,
      AppColors.tertiary,
    ];
    final heights = [90.0, 120.0, 70.0];
    final order = [1, 0, 2]; // 2nd, 1st, 3rd

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: order.map((i) {
          final entry = leaderboard[i];
          final color = colors[i];
          return Expanded(
            child: Column(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: color, width: 2.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      entry.avatarEmoji,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  entry.name,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${entry.totalScore} pts',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  height: heights[i],
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '${i + 1}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
