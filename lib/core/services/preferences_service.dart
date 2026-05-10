import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const _kDarkMode              = 'dark_mode';
  static const _kDiscountNotifications = 'discount_notifications';

  final SharedPreferences _prefs;
  PreferencesService(this._prefs);

  bool get darkMode              => _prefs.getBool(_kDarkMode)              ?? true;
  bool get discountNotifications => _prefs.getBool(_kDiscountNotifications) ?? true;

  Future<void> setDarkMode(bool v)              => _prefs.setBool(_kDarkMode, v);
  Future<void> setDiscountNotifications(bool v) => _prefs.setBool(_kDiscountNotifications, v);
}
