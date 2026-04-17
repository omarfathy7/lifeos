import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:life_os/features/onboarding/cubit/language_cubit.dart';

import 'package:life_os/core/utils/technical_localization.dart';

extension LocalizationExtension on BuildContext {
  bool get isArabic => langCode == 'ar';
  
  String get langCode {
    final languageState = watch<LanguageCubit>().state;
    if (languageState is LanguageSelected) {
      return languageState.locale.languageCode;
    }
    return 'en';
  }

  String translate(String key) => TechnicalLocalization.translate(this, key);
}
