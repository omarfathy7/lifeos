import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:life_os/core/theme/app_colors.dart';
import 'package:life_os/core/router/app_router.dart';
import 'package:life_os/core/utils/localization_extension.dart';
import 'package:life_os/core/widgets/entrance_fader.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Adaptive theme colors based on page index
  Color get _currentThemeColor {
    if (_currentPage == 0) return AppColors.cyan; // Cyan for Step 1
    if (_currentPage == 1) return const Color(0xFF7B2FBE); // Purple for Step 2
    return const Color(0xFFF72585); // Pink for Step 3
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isArabic = context.isArabic;
    final textColor = theme.colorScheme.onSurface;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 60),

            // 1. PageView - The 3 Onboarding Steps
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentPage = index),
                children: [
                  // --- Onboarding 1: Life.OS Introduction ---
                  _buildPageContent(
                    title: context.translate('onboarding_title_1'),
                    description: context.translate('onboarding_desc_1'),
                    themeColor: AppColors.cyan,
                    textColor: textColor,
                    isArabic: isArabic,
                    iconWidget: const Center(
                      child: Text(
                        'OS',
                        style: TextStyle(
                          fontFamily: 'Orbitron',
                          fontWeight: FontWeight.w700,
                          fontSize: 32,
                          color: AppColors.cyan,
                        ),
                      ),
                    ),
                  ),

                  // --- Onboarding 2: The Saga (AI Integration) ---
                  _buildPageContent(
                    title: context.translate('onboarding_title_2'),
                    description: context.translate('onboarding_desc_2'),
                    themeColor: const Color(0xFF7B2FBE),
                    textColor: textColor,
                    isArabic: isArabic,
                    iconWidget: Image.asset(
                      'assets/images/AI.png',
                      fit: BoxFit.cover,
                    ),
                  ),

                  // --- Onboarding 3: Look into the Future (+XP) ---
                  _buildPageContent(
                    title: context.translate('onboarding_title_3'),
                    description: context.translate('onboarding_desc_3'),
                    themeColor: const Color(0xFFF72585),
                    textColor: textColor,
                    isArabic: isArabic,
                    iconWidget: const Center(
                      child: Text(
                        '+XP',
                        style: TextStyle(
                          fontFamily: 'Orbitron',
                          fontWeight: FontWeight.w700,
                          fontSize: 28,
                          color: Color(0xFFF72585),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 2. Footer Section (Indicators & Navigation)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                children: [
                  // Next / Start Journey Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_currentPage < 2) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          _completeOnboarding(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _currentThemeColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        _currentPage == 2 
                            ? context.translate('start_journey') 
                            : context.translate('next'),
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: AppColors.base,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Skip Button
                  Center(
                    child: GestureDetector(
                      onTap: () => _completeOnboarding(context),
                      child: Text(
                        context.translate('skip'),
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          fontSize: 13,
                          color: textColor.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _completeOnboarding(BuildContext context) {
    context.go(AppRoutes.login);
  }

  // --- Helper: Modular Page Content matching the requested design ---
  Widget _buildPageContent({
    required Widget iconWidget,
    required String title,
    required String description,
    required Color themeColor,
    required Color textColor,
    required bool isArabic,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Column(
        crossAxisAlignment: isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Center(
            child: EntranceFader(
              delay: Duration.zero,
              offset: const Offset(0, 10),
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: themeColor.withValues(alpha: 0.2)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: iconWidget,
                ),
              ),
            ),
          ),
          const SizedBox(height: 60),
          EntranceFader(
            delay: const Duration(milliseconds: 100),
            child: Text(
              title,
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                fontSize: 28,
                color: textColor,
              ),
              textAlign: isArabic ? TextAlign.right : TextAlign.left,
            ),
          ),
          const SizedBox(height: 12),
          EntranceFader(
            delay: const Duration(milliseconds: 200),
            child: Text(
              description,
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                fontSize: 15,
                color: textColor.withValues(alpha: 0.5),
                height: 1.5,
              ),
              textAlign: isArabic ? TextAlign.right : TextAlign.left,
            ),
          ),
          const SizedBox(height: 40),
          // Page Indicators positioned below description
          Row(
            mainAxisAlignment: isArabic ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: List.generate(
              3,
              (index) => _buildDot(index: index),
            ),
          ),
        ],
      ),
    );
  }

  // --- Helper: Animated Dot Indicator ---
  Widget _buildDot({required int index}) {
    bool isActive = _currentPage == index;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(right: 8),
      width: isActive ? 20 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive
            ? _currentThemeColor
            : const Color(0xFF888888).withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
