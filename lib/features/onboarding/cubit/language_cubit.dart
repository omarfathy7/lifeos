import 'dart:ui';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'language_state.dart';

class LanguageCubit extends Cubit<LanguageState> {
  LanguageCubit() : super(const LanguageInitial());

  static const _key = 'selected_language';
  
  static const List<String> supportedLanguages = [
    'en', 'ar', 'es', 'fr', 'zh', 'hi', 'ru', 'pt', 'ja', 'de'
  ];

  Future<void> loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    String? code = prefs.getString(_key);
    
    if (code == 'system' || code == null) {
      final systemLocale = PlatformDispatcher.instance.locale.languageCode;
      // Check if system locale is among supported, else default to English
      code = supportedLanguages.contains(systemLocale) ? systemLocale : 'en';
      emit(LanguageSelected(Locale(code), isSystem: true));
    } else {
      emit(LanguageSelected(Locale(code), isSystem: false));
    }
  }

  Future<void> changeLanguage(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, code);
    
    if (code == 'system') {
      final systemLocale = PlatformDispatcher.instance.locale.languageCode;
      final effectiveCode = supportedLanguages.contains(systemLocale) ? systemLocale : 'en';
      emit(LanguageSelected(Locale(effectiveCode), isSystem: true));
    } else {
      emit(LanguageSelected(Locale(code), isSystem: false));
    }
  }
}
