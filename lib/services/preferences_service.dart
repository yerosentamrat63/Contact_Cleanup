import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _keyOnboardingSeen = 'has_seen_onboarding';
  static const String _keyCoachSeen = 'has_seen_coach_mark';

  static Future<bool> hasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyOnboardingSeen) ?? false;
  }

  static Future<void> setOnboardingSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyOnboardingSeen, true);
  }

  static Future<bool> hasSeenCoachMark() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyCoachSeen) ?? false;
  }

  static Future<void> setCoachMarkSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyCoachSeen, true);
  }

  static Future<void> resetAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyOnboardingSeen);
    await prefs.remove(_keyCoachSeen);
  }
}

