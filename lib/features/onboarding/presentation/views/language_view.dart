import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:life_os/core/theme/app_colors.dart';
import 'package:life_os/core/router/app_router.dart';
import 'package:life_os/core/utils/localization_extension.dart';
import 'package:life_os/features/onboarding/cubit/language_cubit.dart';
import 'package:life_os/features/onboarding/cubit/theme_cubit.dart';
import 'package:life_os/core/widgets/entrance_fader.dart';
import 'package:life_os/core/widgets/theme_reveal_wrapper.dart';

class LanguageSelectionView extends StatelessWidget {
  const LanguageSelectionView({super.key});

  static const List<Map<String, String>> _languages = [
    {'name': 'Automatic', 'nativeName': 'Automatic', 'code': 'system'},
    {'name': 'English', 'nativeName': 'English', 'code': 'en'},
    {'name': 'Arabic', 'nativeName': 'العربية', 'code': 'ar'},
    {'name': 'Spanish', 'nativeName': 'Español', 'code': 'es'},
    {'name': 'French', 'nativeName': 'Français', 'code': 'fr'},
    {'name': 'Chinese', 'nativeName': '中文', 'code': 'zh'},
    {'name': 'Hindi', 'nativeName': 'हिन्दी', 'code': 'hi'},
    {'name': 'Russian', 'nativeName': 'Русский', 'code': 'ru'},
    {'name': 'Portuguese', 'nativeName': 'Português', 'code': 'pt'},
    {'name': 'Japanese', 'nativeName': '日本語', 'code': 'ja'},
    {'name': 'German', 'nativeName': 'Deutsch', 'code': 'de'},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onSurface;
    final secondaryTextColor = textColor.withValues(alpha: 0.6);
    final isArabic = context.isArabic;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSectionHeader(context, isArabic, textColor, secondaryTextColor),
              const SizedBox(height: 20),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.asset(
                    'assets/images/helmet_logo.png',
                    width: 72,
                    height: 72,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Center(child: _buildThemeToggle(context, theme)),
              const SizedBox(height: 30),
              Text(
                context.translate('select_language'),
                style: GoogleFonts.orbitron(color: secondaryTextColor, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2),
              ),
              const SizedBox(height: 16),
              _buildLanguageDropdown(context, theme, textColor),
              const Spacer(),
              _buildContinueButton(context),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, bool isArabic, Color textColor, Color secondaryTextColor) {
    return Column(
      crossAxisAlignment: isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        EntranceFader(
          child: Text(
            context.translate('system_settings'),
            style: TextStyle(fontFamily: 'Inter', fontSize: 24, fontWeight: FontWeight.bold, color: textColor),
          ),
        ),
        const SizedBox(height: 8),
        EntranceFader(
          delay: const Duration(milliseconds: 50),
          child: Text(
            context.translate('configure_env'),
            style: TextStyle(fontFamily: 'Inter', fontSize: 15, color: secondaryTextColor, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  Widget _buildThemeToggle(BuildContext context, ThemeData theme) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        final isDark = themeState.themeMode == ThemeMode.dark || 
                      (themeState.themeMode == ThemeMode.system && Theme.of(context).brightness == Brightness.dark);
        
        return Container(
          width: 86,
          height: 36,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: theme.colorScheme.onSurface.withValues(alpha: 0.1)),
          ),
          child: Stack(
            children: [
              AnimatedAlign(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                alignment: isDark ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: const BoxDecoration(
                    color: AppColors.cyan,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTapDown: (details) {
                        ThemeRevealWrapper.of(context)?.setThemeChangePosition(details.globalPosition);
                      },
                      onTap: () => context.read<ThemeCubit>().updateTheme(ThemeMode.light),
                      child: Icon(Icons.wb_sunny_rounded, size: 15, color: !isDark ? AppColors.base : theme.colorScheme.onSurface.withValues(alpha: 0.45)),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTapDown: (details) {
                        ThemeRevealWrapper.of(context)?.setThemeChangePosition(details.globalPosition);
                      },
                      onTap: () => context.read<ThemeCubit>().updateTheme(ThemeMode.dark),
                      child: Icon(Icons.nightlight_round, size: 15, color: isDark ? AppColors.base : theme.colorScheme.onSurface.withValues(alpha: 0.45)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageDropdown(BuildContext context, ThemeData theme, Color textColor) {
    return BlocBuilder<LanguageCubit, LanguageState>(
      builder: (context, state) {
        final selectedCode = state is LanguageSelected && state.isSystem
            ? 'system'
            : state is LanguageSelected
                ? state.locale.languageCode
                : 'system';

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: textColor.withValues(alpha: 0.1)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedCode,
              isExpanded: true,
              borderRadius: BorderRadius.circular(12),
              dropdownColor: theme.colorScheme.surface,
              icon: Icon(Icons.keyboard_arrow_down_rounded, color: textColor.withValues(alpha: 0.7)),
              onChanged: (value) {
                if (value != null) {
                  context.read<LanguageCubit>().changeLanguage(value);
                }
              },
              items: _languages.map((lang) {
                final code = lang['code']!;
                final nativeName = lang['nativeName']!;
                final englishName = lang['name']!;
                return DropdownMenuItem<String>(
                  value: code,
                  child: Row(
                    children: [
                      Icon(
                        code == 'system' ? Icons.auto_awesome : Icons.language,
                        size: 18,
                        color: AppColors.cyan,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          code == 'system' ? nativeName : '$nativeName ($englishName)',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContinueButton(BuildContext context) {
    return EntranceFader(
      delay: const Duration(milliseconds: 300),
      child: ElevatedButton(
        onPressed: () => context.push(AppRoutes.onboarding),
        child: Text(
          context.translate('continue'),
          style: GoogleFonts.orbitron(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 2),
        ),
      ),
    );
  }
}
