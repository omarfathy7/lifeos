import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:life_os/core/router/app_router.dart';
import 'package:life_os/core/theme/app_colors.dart';

class NarrativeView extends StatefulWidget {
  const NarrativeView({super.key});

  @override
  State<NarrativeView> createState() => _NarrativeViewState();
}

class _NarrativeViewState extends State<NarrativeView> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() {
    // Navigate to language screen after 2.5 seconds
    Future.delayed(const Duration(milliseconds: 2500), () {
      // Check if the widget is still in the tree to avoid "async gaps" error
      if (!mounted) return;

      // Using GoRouter as it's already configured in your project
      context.go(AppRoutes.language);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.base,
      body: Center(
        child: TweenAnimationBuilder(
          duration: const Duration(seconds: 2),
          tween: Tween<double>(begin: 0, end: 1),
          builder: (context, double value, child) {
            return Opacity(
              opacity: value,
              child: const Text(
                "Your life, told as a story",
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: AppColors.cyan,
                  letterSpacing: 1.5,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
