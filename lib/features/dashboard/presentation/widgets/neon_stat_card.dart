import 'package:flutter/material.dart';
import 'package:life_os/core/widgets/glass_card.dart';
import 'package:google_fonts/google_fonts.dart';

class NeonStatCard extends StatelessWidget {
  final String title;
  final String percentage;
  final Color neonColor;
  final double progressValue;
  final VoidCallback? onTap;

  const NeonStatCard({
    super.key,
    required this.title,
    required this.percentage,
    required this.neonColor,
    this.progressValue = 0.7,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return GlassCard(
      onTap: onTap,
      opacity: isDark ? 0.05 : 0.4,
      blur: 10,
      baseColor: isDark ? neonColor : Colors.white,
      border: Border.all(color: neonColor.withValues(alpha: 0.2), width: 1),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.orbitron(
              color: neonColor.withValues(alpha: 0.7),
              fontSize: 10,
              letterSpacing: 1.5,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            percentage,
            style: GoogleFonts.inter(
              color: isDark ? Colors.white : Colors.black87,
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),
          // Progress Bar with subtle neon glow
          Stack(
            children: [
              Container(
                height: 4,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: neonColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              FractionallySizedBox(
                widthFactor: progressValue,
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: neonColor,
                    borderRadius: BorderRadius.circular(2),
                    boxShadow: [
                      BoxShadow(
                        color: neonColor.withValues(alpha: 0.4),
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
