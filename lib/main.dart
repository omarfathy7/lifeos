import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:life_os/core/theme/app_theme.dart';
import 'package:life_os/core/router/app_router.dart';
import 'package:life_os/core/widgets/theme_reveal_wrapper.dart';
import 'package:life_os/features/onboarding/cubit/language_cubit.dart';
import 'package:life_os/features/onboarding/cubit/theme_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Future.wait([
      dotenv.load(fileName: '.env'),
      Firebase.initializeApp(),
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]),
    ]);

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
  } catch (e) {
    debugPrint("Initialization Error: $e");
  }

  runApp(const LifeOSApp());
}

class LifeOSApp extends StatelessWidget {
  const LifeOSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LanguageCubit()..loadSavedLanguage()),
        BlocProvider(create: (_) => ThemeCubit()..loadTheme()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return ThemeRevealWrapper(
            themeMode: themeState.themeMode,
            child: BlocBuilder<LanguageCubit, LanguageState>(
              builder: (context, langState) {
                final locale = langState is LanguageSelected
                    ? langState.locale
                    : const Locale('en');

                return MaterialApp.router(
                  title: 'Life.OS',
                  debugShowCheckedModeBanner: false,
                  theme: AppTheme.light,
                  darkTheme: AppTheme.dark,
                  themeMode: themeState.themeMode,
                  locale: locale,
                  supportedLocales: const [
                    Locale('en'), Locale('ar'), Locale('es'), Locale('fr'),
                    Locale('zh'), Locale('hi'), Locale('ru'), Locale('pt'),
                    Locale('ja'), Locale('de'),
                  ],
                  localizationsDelegates: const [
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  routerConfig: appRouter,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
