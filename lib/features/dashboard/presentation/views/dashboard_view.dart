import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:life_os/core/router/app_router.dart';
import 'package:life_os/core/theme/app_colors.dart';
import 'package:life_os/core/utils/localization_extension.dart';
import 'package:life_os/core/widgets/entrance_fader.dart';
import 'package:life_os/core/widgets/glass_card.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/neon_stat_card.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final ScrollController _scrollController = ScrollController();
  bool _showTutorial = false;
  int _tutorialStep = 0;
  final GlobalKey _progressKey = GlobalKey();
  final GlobalKey _statsKey = GlobalKey();
  final GlobalKey _sagaKey = GlobalKey();
  final GlobalKey _questsKey = GlobalKey();

  final List<Map<String, dynamic>> _tutorialSteps = [
    {
      'titleKey': 'tutorial_evolution_title',
      'descKey': 'tutorial_evolution_desc',
      'key': null, // We'll assign them in build
    },
    {
      'titleKey': 'tutorial_metrics_title',
      'descKey': 'tutorial_metrics_desc',
      'key': null,
    },
    {
      'titleKey': 'tutorial_saga_title',
      'descKey': 'tutorial_saga_desc',
      'key': null,
    },
    {
      'titleKey': 'tutorial_quests_title',
      'descKey': 'tutorial_quests_desc',
      'key': null,
    },
  ];
  @override
  void initState() {
    super.initState();
    _checkTutorial();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _checkTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeen = prefs.getBool('has_seen_dashboard_tutorial') ?? false;
    if (!hasSeen) {
      setState(() => _showTutorial = true);
    }
  }

  Future<void> _completeTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_dashboard_tutorial', true);
    setState(() {
      _showTutorial = false;
      _tutorialStep = 0;
    });
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isArabic = context.isArabic;
    final textColor = theme.colorScheme.onSurface;
    final secondaryTextColor = textColor.withValues(alpha: 0.6);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          SafeArea(
            child: ListView(
              controller: _scrollController,
              padding: const EdgeInsets.all(20),
              physics: const BouncingScrollPhysics(),
              children: [
                // ── Header Section ──
                _buildHeader(isArabic, textColor, secondaryTextColor),
                const SizedBox(height: 24),

                // ── Progress & ARC Bento ──
                Container(
                  key: _progressKey,
                  child: _buildProgressBento(isArabic, secondaryTextColor),
                ),
                const SizedBox(height: 24),

                // ── Stats Label ──
                EntranceFader(
                  delay: const Duration(milliseconds: 200),
                  child: Text(
                    context.translate('stats'),
                    style: GoogleFonts.orbitron(
                      color: secondaryTextColor,
                      fontSize: 10,
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: isArabic ? TextAlign.right : TextAlign.left,
                  ),
                ),
                const SizedBox(height: 16),

                // ── Stats Grid (Bento) ──
                Container(
                  key: _statsKey,
                  child: _buildStatsGrid(isArabic),
                ),
                const SizedBox(height: 32),

                // ── Saga Section (Glass) ──
                Container(
                  key: _sagaKey,
                  child: _buildSagaSection(isArabic, textColor, secondaryTextColor, theme),
                ),
                const SizedBox(height: 32),

                // ── Quests Section ──
                EntranceFader(
                  delay: const Duration(milliseconds: 500),
                  child: Container(
                    key: _questsKey,
                    child: _buildQuestsSection(isArabic, textColor, secondaryTextColor, theme),
                  ),
                ),
                const SizedBox(height: 32),

              // ── Future Teaser ──
              GestureDetector(
                onTap: () => context.push(AppRoutes.future),
                child: _buildFutureTeaser(isArabic, textColor, secondaryTextColor, theme),
              ),
                
                const SizedBox(height: 100),
              ],
            ),
          ),
          
          if (_showTutorial) _buildTutorialOverlay(isArabic),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(theme, isArabic, textColor),
    );
  }

  Widget _buildHeader(bool isArabic, Color textColor, Color secondaryTextColor) {
    return EntranceFader(
      delay: Duration.zero,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
        children: [
          Column(
            crossAxisAlignment: isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(
                context.translate('hello_hero'),
                style: GoogleFonts.inter(color: secondaryTextColor, fontSize: 13, fontWeight: FontWeight.w500),
              ),
              Text(
                context.translate('user_name'),
                style: GoogleFonts.inter(
                  color: textColor,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          _buildLvlBadge(isArabic),
        ],
      ),
    );
  }

  Widget _buildLvlBadge(bool isArabic) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.cyan.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.cyan.withValues(alpha: 0.3), width: 1.5),
      ),
      child: Row(
        children: [
          const Icon(Icons.bolt, color: AppColors.cyan, size: 16),
          const SizedBox(width: 4),
          Text(
            context.translate('level_short'),
            style: GoogleFonts.orbitron(
              color: AppColors.cyan,
              fontWeight: FontWeight.w800,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBento(bool isArabic, Color secondaryTextColor) {
    return EntranceFader(
      delay: const Duration(milliseconds: 100),
      child: GlassCard(
        onTap: () => context.push(AppRoutes.experience),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
              children: [
                Text(
                  context.translate('xp_progress'),
                  style: GoogleFonts.orbitron(color: secondaryTextColor, fontSize: 10, fontWeight: FontWeight.bold),
                ),
                Text(
                  context.translate('xp_current_default'),
                  style: GoogleFonts.inter(color: AppColors.cyan, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: 0.0,
                backgroundColor: AppColors.cyan.withValues(alpha: 0.1),
                valueColor: const AlwaysStoppedAnimation(AppColors.cyan),
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 20),
            const Divider(color: Colors.white10),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
              children: [
                Text(
                  context.translate('phase_genesis'),
                  style: GoogleFonts.orbitron(color: const Color(0xFFF72585), fontSize: 10, fontWeight: FontWeight.bold),
                ),
                Text(
                  context.translate('days_left_30'),
                  style: GoogleFonts.inter(color: secondaryTextColor, fontSize: 10, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid(bool isArabic) {
    return EntranceFader(
      delay: const Duration(milliseconds: 300),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.1,
        children: [
          NeonStatCard(
            title: context.translate('discipline'),
            percentage: '0%',
            neonColor: const Color(0xFF00F5D4),
            progressValue: 0.0,
            onTap: () => context.push(AppRoutes.stats),
          ),
          NeonStatCard(
            title: context.translate('health'),
            percentage: '0%',
            neonColor: const Color(0xFF7B2FBE),
            progressValue: 0.0,
            onTap: () => context.push(AppRoutes.stats),
          ),
          NeonStatCard(
            title: context.translate('wealth'),
            percentage: '0%',
            neonColor: const Color(0xFFFFBF1A),
            progressValue: 0.0,
            onTap: () => context.push(AppRoutes.stats),
          ),
          NeonStatCard(
            title: context.translate('focus'),
            percentage: '0%',
            neonColor: const Color(0xFFF72585),
            progressValue: 0.0,
            onTap: () => context.push(AppRoutes.stats),
          ),
        ],
      ),
    );
  }

  Widget _buildSagaSection(bool isArabic, Color textColor, Color secondaryTextColor, ThemeData theme) {
    return EntranceFader(
      delay: const Duration(milliseconds: 400),
      child: Column(
        crossAxisAlignment: isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            context.translate('today_story_chapter'),
            style: GoogleFonts.orbitron(color: secondaryTextColor, fontSize: 10, letterSpacing: 2, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          GlassCard(
            onTap: () => context.push(AppRoutes.saga),
            baseColor: const Color(0xFF7B2FBE),
            opacity: theme.brightness == Brightness.dark ? 0.08 : 0.1,
            child: Row(
              textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
              children: [
                Container(width: 4, height: 60, color: const Color(0xFF7B2FBE)),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    context.translate('saga_placeholder'),
                    style: GoogleFonts.inter(color: textColor.withValues(alpha: 0.9), fontSize: 14, height: 1.6, fontStyle: FontStyle.italic),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestsSection(bool isArabic, Color textColor, Color secondaryTextColor, ThemeData theme) {
    return EntranceFader(
      delay: const Duration(milliseconds: 500),
      child: Column(
        crossAxisAlignment: isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            context.translate('daily_quests'),
            style: GoogleFonts.orbitron(color: secondaryTextColor, fontSize: 10, letterSpacing: 2, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildQuest(theme, context.translate('quest_complete_profile'), false, context.translate('reward_50_xp'), AppColors.cyan, textColor, isArabic),
          const SizedBox(height: 12),
          _buildQuest(theme, context.translate('quest_define_goals'), false, context.translate('reward_30_xp'), AppColors.cyan, textColor, isArabic),
          const SizedBox(height: 12),
          _buildQuest(theme, context.translate('quest_start_first'), false, context.translate('reward_20_xp'), AppColors.cyan, textColor, isArabic),
        ],
      ),
    );
  }

  Widget _buildFutureTeaser(bool isArabic, Color textColor, Color secondaryTextColor, ThemeData theme) {
    return EntranceFader(
      delay: const Duration(milliseconds: 600),
      child: GlassCard(
        baseColor: const Color(0xFFF72585),
        opacity: theme.brightness == Brightness.dark ? 0.05 : 0.1,
        child: Column(
          crossAxisAlignment: isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              context.translate('future_30_days'),
              style: GoogleFonts.orbitron(color: textColor, fontSize: 11, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
              children: [
                Expanded(
                  child: Text(
                    context.translate('future_stats_preview'),
                    style: GoogleFonts.inter(color: secondaryTextColor, fontSize: 11),
                  ),
                ),
                Text(
                  context.translate('simulate'),
                  style: GoogleFonts.orbitron(color: const Color(0xFFF72585), fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _scrollToStep(GlobalKey key) {
    if (key.currentContext != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        alignment: 0.2, // Scroll so the item is near the top
      );
    }
  }

  void _nextTutorialStep() {
    setState(() {
      if (_tutorialStep < _tutorialSteps.length - 1) {
        _tutorialStep++;
        // Auto-scroll to next target
        final nextKey = _tutorialSteps[_tutorialStep]['key'] as GlobalKey?;
        if (nextKey != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToStep(nextKey));
        }
      } else {
        _completeTutorial();
      }
    });
  }

  Widget _buildTutorialOverlay(bool isArabic) {
    // Map keys dynamically
    _tutorialSteps[0]['key'] = _progressKey;
    _tutorialSteps[1]['key'] = _statsKey;
    _tutorialSteps[2]['key'] = _sagaKey;
    _tutorialSteps[3]['key'] = _questsKey;

    final step = _tutorialSteps[_tutorialStep];
    final title = context.translate(step['titleKey'] as String);
    final desc = context.translate(step['descKey'] as String);
    final targetKey = step['key'] as GlobalKey;

    return FutureBuilder<Offset?>(
      future: Future.delayed(const Duration(milliseconds: 100), () => _getWidgetPosition(targetKey)),
      builder: (context, snapshot) {
        final pos = snapshot.data;
        if (pos == null) return const SizedBox.shrink();

        return Stack(
          children: [
            // Transparent Overlay to catch tap anywhere to skip? 
            // The user said next tooltip ONLY when pressing "OK".
            // So we'll use a semi-transparent barrier.
            GestureDetector(
              onTap: () {}, // Do nothing, wait for OK/Skip
              child: Container(color: Colors.black12),
            ),
            
            // Compact Tooltip UI
            Positioned(
              top: pos.dy - 60 > 50 ? pos.dy - 60 : pos.dy + 40, // Adjust to show above or below
              left: 30,
              right: 30,
              child: EntranceFader(
                child: GlassCard(
                  baseColor: AppColors.cyan,
                  opacity: 0.15,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  borderRadius: BorderRadius.circular(12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.bolt, color: AppColors.cyan, size: 14),
                          const SizedBox(width: 8),
                          Text(
                            title,
                            style: GoogleFonts.orbitron(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        desc,
                        style: GoogleFonts.inter(color: Colors.white.withValues(alpha: 0.9), fontSize: 11, height: 1.3),
                        textAlign: isArabic ? TextAlign.right : TextAlign.left,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: _completeTutorial,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              child: Text(
                                context.translate('skip').toUpperCase(),
                                style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: _nextTutorialStep,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.cyan,
                              foregroundColor: Colors.black,
                              elevation: 0,
                              minimumSize: const Size(50, 26),
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                            ),
                            child: Text(
                              context.translate('ok'),
                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Offset? _getWidgetPosition(GlobalKey key) {
    final RenderBox? renderBox = key.currentContext?.findRenderObject() as RenderBox?;
    return renderBox?.localToGlobal(Offset.zero);
  }

  Widget _buildQuest(ThemeData theme, String title, bool done, String xp, Color highlightColor, Color textColor, bool isArabic) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: done
              ? highlightColor.withValues(alpha: 0.2)
              : textColor.withValues(alpha: 0.05),
        ),
      ),
      child: Row(
        textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: done ? highlightColor : Colors.transparent,
              border: Border.all(
                color: done ? highlightColor : textColor.withValues(alpha: 0.3),
              ),
            ),
            child: done
                ? Icon(Icons.check, size: 12, color: theme.colorScheme.surface)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: done ? textColor.withValues(alpha: 0.5) : textColor,
                fontSize: 13,
                decoration: done ? TextDecoration.lineThrough : null,
              ),
              textAlign: isArabic ? TextAlign.right : TextAlign.left,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: highlightColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(xp, style: TextStyle(color: highlightColor, fontSize: 10)),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(ThemeData theme, bool isArabic, Color textColor) {
    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(top: BorderSide(color: textColor.withValues(alpha: 0.1), width: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
        children: [
          _navItem(context.translate('home'), Icons.home, true),
          _navItem(context.translate('quests_nav'), Icons.bolt, false),
          _navItem(context.translate('saga_nav'), Icons.menu_book, false),
          _navItem(context.translate('future_nav'), Icons.auto_awesome, false),
          _navItem(context.translate('profile'), Icons.person, false),
        ],
      ),
    );
  }

  Widget _navItem(String label, IconData icon, bool active) {
    const activeColor = Color(0xFF00F5D4);
    const inactiveColor = Color(0xFF888888);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (active)
          Container(
            width: 20,
            height: 3,
            margin: const EdgeInsets.only(bottom: 4),
            decoration: BoxDecoration(
              color: activeColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        Icon(icon, color: active ? activeColor : inactiveColor, size: 22),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: active ? activeColor : inactiveColor,
            fontSize: 9,
            fontWeight: active ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
