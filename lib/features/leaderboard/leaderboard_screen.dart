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
      decoration: const BoxDecoration(gradient: LinearGradient(
        colors: [Color(0xFFF8F9FF), Color(0xFFEEF0FF)],
        begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      child: SafeArea(child: Column(children: [
        const Padding(padding: EdgeInsets.all(20),
          child: Text('Bang xep hang', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.textPrimary))),

        // Top 3 podium
        if (leaderboard.length >= 3) _buildPodium(leaderboard),
        const SizedBox(height: 16),

        // Rest of leaderboard
        Expanded(child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(24),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))]),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: leaderboard.length > 3 ? leaderboard.length - 3 : 0,
            itemBuilder: (ctx, index) {
              final entry = leaderboard[index + 3];
              bool isCurrentUser = entry.name == appProvider.userName;
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isCurrentUser ? AppColors.primaryPurple.withValues(alpha: 0.08) : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                  border: isCurrentUser ? Border.all(color: AppColors.primaryPurple.withValues(alpha: 0.3), width: 2) : null),
                child: Row(children: [
                  SizedBox(width: 30, child: Text('${entry.rank}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700,
                      color: isCurrentUser ? AppColors.primaryPurple : AppColors.textSecondary))),
                  Container(width: 40, height: 40,
                    decoration: BoxDecoration(
                      color: isCurrentUser ? AppColors.primaryPurple.withValues(alpha: 0.15) : Colors.grey.shade100,
                      shape: BoxShape.circle),
                    child: Center(child: Text(entry.avatarEmoji,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,
                        color: isCurrentUser ? AppColors.primaryPurple : AppColors.textSecondary)))),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(isCurrentUser ? '${entry.name} (Ban)' : entry.name,
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600,
                        color: isCurrentUser ? AppColors.primaryPurple : AppColors.textPrimary)),
                    Text('${entry.streakDays} ngay lien tiep',
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  ])),
                  Text('${entry.totalScore}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700,
                    color: isCurrentUser ? AppColors.primaryPurple : AppColors.textPrimary)),
                  const SizedBox(width: 4),
                  const Icon(Icons.star_rounded, color: AppColors.starGold, size: 18),
                ]));
            }))),
        const SizedBox(height: 16),
      ])));
  }

  Widget _buildPodium(List leaderboard) {
    final medals = [AppColors.starSilver, AppColors.starGold, AppColors.starBronze];
    final heights = [100.0, 130.0, 80.0];
    final order = [1, 0, 2]; // 2nd, 1st, 3rd

    return Padding(padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end,
        children: order.map((i) {
          final entry = leaderboard[i];
          return Expanded(child: Column(children: [
            Container(width: 50, height: 50,
              decoration: BoxDecoration(
                gradient: i == 0 ? AppColors.sunsetGradient : i == 1 ? AppColors.coolGradient : AppColors.primaryGradient,
                shape: BoxShape.circle,
                border: Border.all(color: medals[i], width: 3)),
              child: Center(child: Text(entry.avatarEmoji,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)))),
            const SizedBox(height: 6),
            Text(entry.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis),
            Text('${entry.totalScore}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: medals[i])),
            const SizedBox(height: 8),
            Container(width: double.infinity, height: heights[i],
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [medals[i], medals[i].withValues(alpha: 0.6)],
                  begin: Alignment.topCenter, end: Alignment.bottomCenter),
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))),
              child: Center(child: Text('${i + 1}',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white)))),
          ]));
        }).toList()));
  }
}
