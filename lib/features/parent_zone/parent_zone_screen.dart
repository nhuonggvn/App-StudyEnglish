import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/app_provider.dart';
import '../../core/services/notification_service.dart';

class ParentZoneScreen extends StatefulWidget {
  const ParentZoneScreen({super.key});

  @override
  State<ParentZoneScreen> createState() => _ParentZoneScreenState();
}

class _ParentZoneScreenState extends State<ParentZoneScreen> {
  bool _reminderEnabled = false;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 18, minute: 0);

  @override
  void initState() {
    super.initState();
    _loadReminderSettings();
  }

  Future<void> _loadReminderSettings() async {
    final notifService = NotificationService();
    bool enabled = await notifService.isReminderEnabled();
    Map<String, int> time = await notifService.getReminderTime();
    if (mounted) {
      setState(() {
        _reminderEnabled = enabled;
        _reminderTime = TimeOfDay(hour: time['hour'] ?? 18, minute: time['minute'] ?? 0);
      });
    }
  }

  Future<void> _toggleReminder(bool value) async {
    final notifService = NotificationService();
    if (value) {
      await notifService.scheduleDailyReminder(hour: _reminderTime.hour, minute: _reminderTime.minute);
    } else {
      await notifService.cancelAllReminders();
    }
    setState(() { _reminderEnabled = value; });
  }

  Future<void> _pickReminderTime() async {
    final picked = await showTimePicker(context: context, initialTime: _reminderTime);
    if (picked != null) {
      setState(() { _reminderTime = picked; });
      if (_reminderEnabled) {
        final notifService = NotificationService();
        await notifService.scheduleDailyReminder(hour: picked.hour, minute: picked.minute);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();
    final report = appProvider.weeklyReport;

    return Container(
      decoration: const BoxDecoration(gradient: LinearGradient(
        colors: [Color(0xFFF8F9FF), Color(0xFFEEF0FF)],
        begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      child: SafeArea(child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Goc phu huynh', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
          const SizedBox(height: 4),
          Text('Bao cao hoc tap cua ${appProvider.userName}',
            style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
          const SizedBox(height: 24),

          // Stats overview
          Row(children: [
            Expanded(child: _buildStatCard('Tong diem', '${appProvider.totalScore}', Icons.star_rounded, AppColors.starGold)),
            const SizedBox(width: 12),
            Expanded(child: _buildStatCard('Tu da hoc', '${appProvider.learnedWordsCount}', Icons.menu_book_rounded, AppColors.primaryGreen)),
          ]),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: _buildStatCard('Buoi hoc', '${report.totalSessions}', Icons.school_rounded, AppColors.primaryBlue)),
            const SizedBox(width: 12),
            Expanded(child: _buildStatCard('Streak', '${appProvider.streakDays} ngay', Icons.local_fire_department_rounded, AppColors.primaryOrange)),
          ]),
          const SizedBox(height: 24),

          // Weekly activity chart
          const Text('Hoat dong trong tuan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          Container(height: 200, padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))]),
            child: BarChart(BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: 35,
              barTouchData: BarTouchData(enabled: false),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 30,
                  getTitlesWidget: (value, meta) {
                    final days = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
                    int idx = value.toInt();
                    if (idx >= 0 && idx < days.length) {
                      return Text(days[idx], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textSecondary));
                    }
                    return const Text('');
                  })),
                leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              gridData: const FlGridData(show: false),
              barGroups: List.generate(7, (i) {
                final values = report.dailyActivity.values.toList();
                double val = i < values.length ? values[i].toDouble() : 0;
                return BarChartGroupData(x: i, barRods: [
                  BarChartRodData(toY: val, width: 20,
                    gradient: AppColors.primaryGradient,
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6))),
                ]);
              }),
            ))),
          const SizedBox(height: 24),

          // Accuracy
          const Text('Ti le dung', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          Container(padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))]),
            child: Row(children: [
              SizedBox(width: 80, height: 80,
                child: Stack(alignment: Alignment.center, children: [
                  CircularProgressIndicator(
                    value: report.accuracyRate / 100,
                    strokeWidth: 8, backgroundColor: AppColors.primaryGreen.withValues(alpha: 0.15),
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryGreen)),
                  Text('${report.accuracyRate.round()}%',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.primaryGreen)),
                ])),
              const SizedBox(width: 20),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Ty le tra loi dung', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(report.accuracyRate >= 80 ? 'Rat tot! Con dang tien bo nhanh!' :
                  report.accuracyRate >= 50 ? 'Tot! Hay tiep tuc co gang!' : 'Hay luyen tap them nhe!',
                  style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
              ])),
            ])),
          const SizedBox(height: 24),

          // Reminder settings
          const Text('Nhac nho hoc tap', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          Container(padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))]),
            child: Column(children: [
              Row(children: [
                Container(width: 44, height: 44,
                  decoration: BoxDecoration(color: AppColors.primaryOrange.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(14)),
                  child: const Icon(Icons.notifications_active_rounded, color: AppColors.primaryOrange)),
                const SizedBox(width: 14),
                const Expanded(child: Text('Nhac nho moi ngay', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
                Switch.adaptive(
                  value: _reminderEnabled, onChanged: _toggleReminder,
                  thumbColor: WidgetStateProperty.resolveWith((states) =>
                    states.contains(WidgetState.selected) ? AppColors.primaryGreen : null),
                  trackColor: WidgetStateProperty.resolveWith((states) =>
                    states.contains(WidgetState.selected) ? AppColors.primaryGreen.withValues(alpha: 0.3) : null)),
              ]),
              if (_reminderEnabled) ...[
                const Divider(height: 24),
                GestureDetector(onTap: _pickReminderTime,
                  child: Row(children: [
                    const Icon(Icons.access_time_rounded, color: AppColors.primaryBlue),
                    const SizedBox(width: 12),
                    const Text('Gio nhac nho:', style: TextStyle(fontSize: 15)),
                    const Spacer(),
                    Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(color: AppColors.primaryBlue.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                      child: Text(_reminderTime.format(context),
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primaryBlue))),
                  ])),
              ],
            ])),
          const SizedBox(height: 20),
        ]))));
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 3))]),
      child: Row(children: [
        Container(width: 44, height: 44,
          decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(14)),
          child: Icon(icon, color: color, size: 22)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: color)),
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        ])),
      ]));
  }
}
