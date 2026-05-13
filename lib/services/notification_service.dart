import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

class NotificationService {
  static NotificationService? _instance;
  NotificationService._();
  static NotificationService get instance =>
      _instance ??= NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const int _reminderId = 42;

  Future<void> initialize() async {
    tz_data.initializeTimeZones();

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);

    await _plugin.initialize(settings);

    // Request permissions on Android 13+
    if (Platform.isAndroid) {
      final androidPlugin =
          _plugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      await androidPlugin?.requestNotificationsPermission();
      await androidPlugin?.requestExactAlarmsPermission();
    }
  }

  /// Планирует уведомление через [delay] от текущего момента
  Future<void> scheduleReminder(Duration delay) async {
    await cancelAll();

    final scheduledDate = tz.TZDateTime.now(tz.local).add(delay);

    const androidDetails = AndroidNotificationDetails(
      'quiz_reminder_channel',
      'Напоминания о тесте',
      channelDescription: 'Уведомления с напоминанием пройти Flutter Quiz',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const details = NotificationDetails(android: androidDetails);

    await _plugin.zonedSchedule(
      _reminderId,
      '📚 Время пройти тест!',
      'Ваши знания Flutter ждут проверки. Открывайте Flutter Quiz!',
      scheduledDate,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );

    debugPrint('[NotificationService] Reminder scheduled at $scheduledDate');
  }

  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }
}
