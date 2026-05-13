import 'package:flutter/material.dart';
import '../services/notification_service.dart';

enum ReminderOption { fiveMin, thirtyMin, oneHour, threeHours, custom }

extension ReminderOptionLabel on ReminderOption {
  String get label {
    switch (this) {
      case ReminderOption.fiveMin:
        return 'Через 5 минут';
      case ReminderOption.thirtyMin:
        return 'Через 30 минут';
      case ReminderOption.oneHour:
        return 'Через 1 час';
      case ReminderOption.threeHours:
        return 'Через 3 часа';
      case ReminderOption.custom:
        return 'Своё время';
    }
  }

  Duration? get duration {
    switch (this) {
      case ReminderOption.fiveMin:
        return const Duration(minutes: 5);
      case ReminderOption.thirtyMin:
        return const Duration(minutes: 30);
      case ReminderOption.oneHour:
        return const Duration(hours: 1);
      case ReminderOption.threeHours:
        return const Duration(hours: 3);
      case ReminderOption.custom:
        return null; // handled separately
    }
  }
}

class NotificationViewModel extends ChangeNotifier {
  ReminderOption _selectedOption = ReminderOption.thirtyMin;
  ReminderOption get selectedOption => _selectedOption;

  int _customMinutes = 60;
  int get customMinutes => _customMinutes;

  bool _isScheduled = false;
  bool get isScheduled => _isScheduled;

  String? _statusMessage;
  String? get statusMessage => _statusMessage;

  void selectOption(ReminderOption option) {
    _selectedOption = option;
    _isScheduled = false;
    _statusMessage = null;
    notifyListeners();
  }

  void setCustomMinutes(int minutes) {
    _customMinutes = minutes.clamp(1, 10080); // max 1 week
    notifyListeners();
  }

  Duration get selectedDuration {
    if (_selectedOption == ReminderOption.custom) {
      return Duration(minutes: _customMinutes);
    }
    return _selectedOption.duration!;
  }

  Future<void> scheduleReminder() async {
    try {
      await NotificationService.instance.scheduleReminder(selectedDuration);
      _isScheduled = true;
      final mins = selectedDuration.inMinutes;
      final label = mins < 60
          ? '$mins мин.'
          : '${selectedDuration.inHours} ч.';
      _statusMessage = '✅ Напоминание через $label запланировано!';
    } catch (e) {
      _isScheduled = false;
      _statusMessage = '❌ Ошибка: $e';
    }
    notifyListeners();
  }

  Future<void> cancelReminder() async {
    await NotificationService.instance.cancelAll();
    _isScheduled = false;
    _statusMessage = 'Напоминание отменено.';
    notifyListeners();
  }
}
