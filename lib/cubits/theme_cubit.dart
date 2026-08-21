import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  static const String _themeKey = 'is_dark_mode';

  ThemeCubit() : super(ThemeMode.dark) {
    _loadThemeFromPrefs(); // تحميل الوضع المحفوظ عند بداية التطبيق
  }

  // تبديل الثيم وحفظ الحالة الجديدة
  Future<void> toggleTheme() async {
    final newMode = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    emit(newMode);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, newMode == ThemeMode.dark);
  }

  // قراءة الحالة المحفوظة في الموبايل
  Future<void> _loadThemeFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool(_themeKey) ?? true; // الافتراضي Dark
    emit(isDark ? ThemeMode.dark : ThemeMode.light);
  }
}