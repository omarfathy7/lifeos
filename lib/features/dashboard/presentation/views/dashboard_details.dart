import 'package:flutter/material.dart';
import 'package:life_os/core/theme/app_colors.dart';
import 'package:life_os/core/utils/localization_extension.dart';
import 'package:life_os/core/widgets/entrance_fader.dart';
import 'package:life_os/core/widgets/glass_card.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardDetailBase extends StatelessWidget {
  final String title;
  final Widget child;

  const DashboardDetailBase({
    super.key,
    required this.title,
    required this.child,
  });

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
            _buildHeader(context, isArabic, textColor),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                physics: const BouncingScrollPhysics(),
                children: [
                  EntranceFader(child: child),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isArabic, Color textColor) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Row(
        textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
        children: [
          IconButton(
            icon: Icon(
              isArabic ? Icons.arrow_back_ios : Icons.arrow_back_ios_new,
              color: textColor,
              size: 20,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: GoogleFonts.orbitron(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }
}

class StatsDetailView extends StatelessWidget {
  const StatsDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isArabic = context.isArabic;
    final textColor = theme.colorScheme.onSurface;

    return DashboardDetailBase(
      title: context.translate('stats'),
      child: Column(
        children: [
          _statItem(context.translate('discipline'), '0%', const Color(0xFF00F5D4), 0.0, isArabic, textColor),
          _statItem(context.translate('health'), '0%', const Color(0xFF7B2FBE), 0.0, isArabic, textColor),
          _statItem(context.translate('wealth'), '0%', const Color(0xFFFFBF1A), 0.0, isArabic, textColor),
          _statItem(context.translate('focus'), '0%', const Color(0xFFF72585), 0.0, isArabic, textColor),
        ],
      ),
    );
  }

  Widget _statItem(String label, String value, Color color, double progress, bool isArabic, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: GlassCard(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
              children: [
                Text(
                  label,
                  style: GoogleFonts.orbitron(color: textColor.withValues(alpha: 0.8), fontSize: 12, fontWeight: FontWeight.bold),
                ),
                Text(
                  value,
                  style: GoogleFonts.orbitron(color: color, fontSize: 16, fontWeight: FontWeight.w900),
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: color.withValues(alpha: 0.1),
              valueColor: AlwaysStoppedAnimation(color),
              minHeight: 12,
              borderRadius: BorderRadius.circular(6),
            ),
          ],
        ),
      ),
    );
  }
}

class SagaDetailView extends StatelessWidget {
  const SagaDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onSurface;

    return DashboardDetailBase(
      title: context.translate('saga'),
      child: Column(
        children: [
          const Icon(Icons.auto_stories, color: Color(0xFF7B2FBE), size: 64),
          const SizedBox(height: 32),
          Text(
            context.translate('intro_title'),
            style: GoogleFonts.orbitron(color: textColor, fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            context.translate('saga_placeholder'),
            style: GoogleFonts.inter(color: textColor, fontSize: 15, fontWeight: FontWeight.w500, height: 1.6),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class QuestsDetailView extends StatelessWidget {
  const QuestsDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isArabic = context.isArabic;
    final textColor = theme.colorScheme.onSurface;

    return DashboardDetailBase(
      title: context.translate('quests'),
      child: Column(
        children: [
          _questItem(context.translate('quest_complete_profile'), context.translate('reward_50_xp'), isArabic, textColor),
          _questItem(context.translate('quest_define_goals'), context.translate('reward_30_xp'), isArabic, textColor),
          _questItem(context.translate('quest_start_first'), context.translate('reward_20_xp'), isArabic, textColor),
        ],
      ),
    );
  }

  Widget _questItem(String title, String reward, bool isArabic, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
          children: [
            Container(width: 12, height: 12, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.cyan, width: 2))),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.inter(color: textColor, fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
            Text(
              reward,
              style: GoogleFonts.orbitron(color: AppColors.cyan, fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class FutureDetailView extends StatelessWidget {
  const FutureDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onSurface;

    return DashboardDetailBase(
      title: context.translate('future'),
      child: Column(
        children: [
          const Icon(Icons.blur_on, color: Color(0xFFF72585), size: 64),
          const SizedBox(height: 32),
          Text(
            context.translate('future'),
            style: GoogleFonts.orbitron(color: textColor, fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          GlassCard(
            padding: const EdgeInsets.all(24),
            child: Text(
              context.translate('future_detail_desc'),
              style: GoogleFonts.inter(color: textColor, fontSize: 15, fontWeight: FontWeight.w500, height: 1.6),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class ExperienceDetailView extends StatelessWidget {
  const ExperienceDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onSurface;

    return DashboardDetailBase(
      title: context.translate('progress'),
      child: Column(
        children: [
          const Icon(Icons.bolt, color: AppColors.cyan, size: 64),
          const SizedBox(height: 32),
          Text(
            context.translate('level'),
            style: GoogleFonts.orbitron(color: textColor, fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 4),
          ),
          const SizedBox(height: 8),
          Text(
            context.translate('phase_genesis'),
            style: GoogleFonts.orbitron(color: AppColors.cyan, fontSize: 12, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 48),
          GlassCard(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.translate('xp'),
                      style: GoogleFonts.orbitron(color: textColor.withValues(alpha: 0.8), fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      context.translate('xp_current_default'),
                      style: GoogleFonts.inter(color: AppColors.cyan, fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                LinearProgressIndicator(
                  value: 0.05, // Subtle start
                  backgroundColor: AppColors.cyan.withValues(alpha: 0.1),
                  valueColor: const AlwaysStoppedAnimation(AppColors.cyan),
                  minHeight: 12,
                  borderRadius: BorderRadius.circular(6),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Text(
            context.translate('experience_detail_desc'),
            style: GoogleFonts.inter(color: textColor, fontSize: 15, fontWeight: FontWeight.w500, height: 1.6),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
