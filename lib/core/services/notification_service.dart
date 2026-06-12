import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    try {
      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const DarwinInitializationSettings iosSettings =
          DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const InitializationSettings initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _notificationsPlugin.initialize(initSettings);
      _isInitialized = true;
    } catch (e) {
      _isInitialized = false;
    }
  }

  Future<void> scheduleDailyReminder({
    required int hour,
    required int minute,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('reminder_hour', hour);
      await prefs.setInt('reminder_minute', minute);
      await prefs.setBool('reminder_enabled', true);

      // Use periodic notification instead of zonedSchedule to avoid timezone dependency
      await _notificationsPlugin.periodicallyShow(
        0,
        'KidEnglish - Den gio hoc roi!',
        'Hay cung hoc tieng Anh nao! Nhieu tro choi vui dang cho con!',
        RepeatInterval.daily,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'daily_reminder',
            'Nhac nho hoc tap',
            channelDescription: 'Nhac nho hoc tieng Anh hang ngay',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
    } catch (e) {
      // Notification scheduling failed
    }
  }

  Future<void> cancelAllReminders() async {
    try {
      await _notificationsPlugin.cancelAll();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('reminder_enabled', false);
    } catch (e) {
      // Cancel failed
    }
  }

  Future<bool> isReminderEnabled() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool('reminder_enabled') ?? false;
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, int>> getReminderTime() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return {
        'hour': prefs.getInt('reminder_hour') ?? 18,
        'minute': prefs.getInt('reminder_minute') ?? 0,
      };
    } catch (e) {
      return {'hour': 18, 'minute': 0};
    }
  }
}
