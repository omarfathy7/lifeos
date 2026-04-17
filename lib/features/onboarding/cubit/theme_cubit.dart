import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState(ThemeMode.system));

  // Local storage save key
  static const String _themeKey = 'selected_theme';

  // Load saved theme on app launch
  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString(_themeKey);

    if (savedTheme == 'dark') {
      emit(const ThemeState(ThemeMode.dark));
    } else if (savedTheme == 'light') {
      emit(const ThemeState(ThemeMode.light));
    } else {
      emit(const ThemeState(ThemeMode.system));
    }
  }

  // Change and save theme
  Future<void> updateTheme(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _themeKey,
      mode.name,
    ); // Saves 'dark', 'light', or 'system'
    emit(ThemeState(mode));
  }
}
