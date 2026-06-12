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

    final pathColors = [
      AppColors.primaryPink, AppColors.primaryBlue, AppColors.primaryGreen,
      AppColors.primaryOrange, AppColors.primaryPurple, AppColors.primaryTeal,
      AppColors.primaryRed, AppColors.primaryYellow,
    ];

    return Container(
      decoration: const BoxDecoration(gradient: LinearGradient(
        colors: [Color(0xFFF8F9FF), Color(0xFFEEF0FF)],
        begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      child: SafeArea(child: Column(children: [
        Padding(padding: const EdgeInsets.all(20), child: Row(children: [
          const Expanded(child: Text('Lo trinh hoc tap',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.textPrimary))),
          Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: AppColors.primaryPurple.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(16)),
            child: Text(appProvider.ageGroupLabel,
              style: const TextStyle(color: AppColors.primaryPurple, fontSize: 13, fontWeight: FontWeight.w600))),
        ])),
        Expanded(child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: pathItems.length,
          itemBuilder: (context, index) {
            final item = pathItems[index];
            Color color = pathColors[index % pathColors.length];
            bool isLast = index == pathItems.length - 1;

            return Column(children: [
              // Connector line
              if (index > 0)
                Container(width: 3, height: 30,
                  color: item.isLocked ? Colors.grey.shade300 : color.withValues(alpha: 0.3)),
              // Topic node
              GestureDetector(
                onTap: item.isLocked ? null : () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => GameSelectionScreen(topic: topics[index])));
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: item.isLocked ? Colors.grey.shade100 : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: item.isLocked ? Colors.grey.shade300 : color.withValues(alpha: 0.3), width: 2),
                    boxShadow: item.isLocked ? [] : [BoxShadow(color: color.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 4))]),
                  child: Row(children: [
                    Container(width: 56, height: 56,
                      decoration: BoxDecoration(
                        color: item.isLocked ? Colors.grey.shade200 : color.withValues(alpha: 0.15),
                        shape: BoxShape.circle),
                      child: Center(child: item.isLocked
                        ? Icon(Icons.lock_rounded, color: Colors.grey.shade400, size: 24)
                        : item.isCompleted
                          ? Icon(Icons.check_rounded, color: color, size: 28)
                          : Text(item.emoji, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)))),
                    const SizedBox(width: 14),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(item.topicName, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700,
                        color: item.isLocked ? Colors.grey : AppColors.textPrimary)),
                      const SizedBox(height: 4),
                      Text('${item.completedLessons}/${item.totalLessons} bai',
                        style: TextStyle(fontSize: 13, color: item.isLocked ? Colors.grey : AppColors.textSecondary)),
                      if (!item.isLocked) ...[
                        const SizedBox(height: 8),
                        ClipRRect(borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(value: item.progress,
                            backgroundColor: color.withValues(alpha: 0.15),
                            valueColor: AlwaysStoppedAnimation<Color>(color), minHeight: 6)),
                      ],
                    ])),
                    if (!item.isLocked)
                      Icon(Icons.arrow_forward_ios_rounded, color: color, size: 18),
                  ]))),
              if (!isLast)
                Container(width: 3, height: 30,
                  color: pathItems[index + 1].isLocked ? Colors.grey.shade300 : pathColors[(index + 1) % pathColors.length].withValues(alpha: 0.3)),
            ]);
          })),
      ])));
  }
}
