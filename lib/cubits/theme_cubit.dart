import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  static const String _themeKey = 'is_dark_mode';//shared preference key

  ThemeCubit() : super(ThemeMode.dark) {
    _loadThemeFromPrefs(); //عشان اعرف المستخدم كان مختار ايه اخر مره 
    }
  
  Future<void> toggleTheme() async {
    final newMode = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    emit(newMode);

    final prefs = await SharedPreferences.getInstance();//تخزين اخر وضع 
    await prefs.setBool(_themeKey, newMode == ThemeMode.dark);
  }

  Future<void> _loadThemeFromPrefs() async {//اقرا الثيم المحفوظ 
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool(_themeKey) ?? true; //لو التطبيق لسا فاتح ومفيش حاجه محفوظه بيعمل ال default الي هو ال dark mode
    emit(isDark ? ThemeMode.dark : ThemeMode.light);
  }
}