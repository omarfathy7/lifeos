import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:life_os/core/theme/app_colors.dart';
import 'package:life_os/core/router/app_router.dart';
import 'package:life_os/core/utils/localization_extension.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;
  String _displayText = "";
  String _fullText = "";
  bool _typewriterStarted = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _progressAnimation = Tween<double>(begin: 0, end: 200).animate(_controller)
      ..addListener(() => setState(() {}));

    _controller.forward();

    // Logic: Only skip to Dashboard if actually logged in. 
    // Otherwise, always show the full Intro sequence.
    // Speed up logic: reduce total delay to 2 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        context.go(AppRoutes.dashboard);
      } else {
        context.go(AppRoutes.intro);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_typewriterStarted) return;
    _fullText = context.translate('booting');
    _typewriterStarted = true;
    _startTypewriter();
  }

  void _startTypewriter() async {
    for (int i = 0; i <= _fullText.length; i++) {
      if (!mounted) return;
      setState(() => _displayText = _fullText.substring(0, i));
      await Future.delayed(const Duration(milliseconds: 35));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Preferred Astronaut Background
          Positioned.fill(
            child: Image.asset(
              'assets/images/astronauts.png',
              fit: BoxFit.cover,
            ),
          ),
          // Subtle Dark Overlay to ensure readability
          Positioned.fill(child: Container(color: Colors.black.withValues(alpha: 0.6))),
          
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 100.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _displayText,
                    style: TextStyle(
                      fontFamily: 'Orbitron',
                      fontSize: 14,
                      color: AppColors.cyan.withValues(alpha: 0.8),
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Stack(
                      alignment: Alignment.topLeft,
                      children: [
                        Container(
                          width: 200,
                          height: 2,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        Container(
                          width: _progressAnimation.value,
                          height: 2,
                          decoration: BoxDecoration(
                            color: AppColors.cyan,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.cyan.withValues(alpha: 0.5),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
