import 'package:shared_preferences/shared_preferences.dart';

class PrefsService {
  static const _keyOnboardingDone = 'onboarding_done';

  static PrefsService? _instance;
  PrefsService._();
  static PrefsService get instance => _instance ??= PrefsService._();

  Future<bool> isOnboardingDone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyOnboardingDone) ?? false;
  }

  Future<void> setOnboardingDone() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyOnboardingDone, true);
  }
}
