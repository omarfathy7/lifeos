import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class LanguageButton extends StatelessWidget {
  final String title;
  final String subTitle;
  final bool isSelected;

  const LanguageButton({
    super.key,
    required this.title,
    required this.subTitle,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 310,
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected
              ? AppColors.cyan.withValues(alpha: 0.5)
              : Colors.transparent,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                subTitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          // Checkmark circle (Ellipse)
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? AppColors.cyan : const Color(0xFF1C1C21),
              border: isSelected
                  ? null
                  : Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: isSelected
                ? const Icon(Icons.check, size: 14, color: AppColors.base)
                : null,
          ),
        ],
      ),
    );
  }
}
