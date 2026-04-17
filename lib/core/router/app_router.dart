import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Import your screens
import 'package:life_os/features/onboarding/presentation/views/splash_view.dart';
import 'package:life_os/features/onboarding/presentation/views/story_intro_view.dart';
import 'package:life_os/features/onboarding/presentation/views/language_view.dart';
import 'package:life_os/features/onboarding/presentation/views/onboarding_view.dart';
import 'package:life_os/features/auth/presentation/views/login_view.dart';
import 'package:life_os/features/auth/presentation/views/register_view.dart';
import 'package:life_os/features/dashboard/presentation/views/dashboard_view.dart';
import 'package:life_os/features/dashboard/presentation/views/dashboard_details.dart';

abstract final class AppRoutes {
  static const String splash = '/';
  static const String intro = '/intro';
  static const String language = '/language';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String dashboard = '/dashboard';
  static const String stats = '/stats';
  static const String saga = '/saga';
  static const String quests = '/quests';
  static const String future = '/future';
  static const String experience = '/experience';
}

/// Helper class making GoRouter reactive to Stream changes (e.g., Firebase Auth)
class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<dynamic> _subscription;

  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (dynamic _) => notifyListeners(),
    );
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final appRouter = GoRouter(
  initialLocation: AppRoutes.splash,

  // Magic link with Firebase: User state changes trigger immediate redirect
  refreshListenable: GoRouterRefreshStream(
    FirebaseAuth.instance.authStateChanges(),
  ),

  redirect: (context, state) {
    final user = FirebaseAuth.instance.currentUser;
    final bool isLoggedIn = user != null;

    // Determine current user location
    final bool isLoggingIn =
        state.matchedLocation == AppRoutes.login ||
        state.matchedLocation == AppRoutes.register;

    final bool isOnboarding =
        state.matchedLocation == AppRoutes.intro ||
        state.matchedLocation == AppRoutes.language ||
        state.matchedLocation == AppRoutes.onboarding;

    // Redirect Logic Refinement:
    // Only jump to dashboard if we are currently at login/register/onboarding.
    // We REMOVE the splash check here so the app always shows the boot animation.
    if (isLoggedIn && (isLoggingIn || isOnboarding)) {
      return AppRoutes.dashboard;
    }

    // 2. Protection logic and external routing (Not Logged In)
    if (!isLoggedIn && state.matchedLocation == AppRoutes.dashboard) {
      return AppRoutes.login;
    }

    // Proceed with natural route
    return null;
  },

  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashView(),
    ),
    GoRoute(
      path: AppRoutes.intro,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const StoryIntroView(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    ),
    GoRoute(
      path: AppRoutes.language,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const LanguageSelectionView(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const OnboardingView(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    ),
    GoRoute(
      path: AppRoutes.login,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const LoginView(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 0.05); // Subtle 5% slide
          const end = Offset.zero;
          final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: Curves.easeOut));
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(position: animation.drive(tween), child: child),
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    ),
    GoRoute(
      path: AppRoutes.register,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const RegisterView(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    ),
    GoRoute(
      path: AppRoutes.dashboard,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const DashboardView(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: CurveTween(curve: Curves.easeIn).animate(animation),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 400), // Slightly longer for dashboard boot
      ),
    ),
    GoRoute(
      path: AppRoutes.stats,
      builder: (context, state) => const StatsDetailView(),
    ),
    GoRoute(
      path: AppRoutes.saga,
      builder: (context, state) => const SagaDetailView(),
    ),
    GoRoute(
      path: AppRoutes.quests,
      builder: (context, state) => const QuestsDetailView(),
    ),
    GoRoute(
      path: AppRoutes.future,
      builder: (context, state) => const FutureDetailView(),
    ),
    GoRoute(
      path: AppRoutes.experience,
      builder: (context, state) => const ExperienceDetailView(),
    ),
  ],
);
