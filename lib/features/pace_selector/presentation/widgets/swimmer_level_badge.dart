import 'package:flutter/material.dart';
import 'package:swim_success/app/theme.dart';
import 'package:swim_success/core/constants/pace_constants.dart';

class SwimmerLevelBadge extends StatelessWidget {
  const SwimmerLevelBadge({super.key, required this.level});

  final SwimmerLevel level;

  Color get _levelColor {
    return switch (level) {
      SwimmerLevel.elite => const Color(0xFFFFD700),
      SwimmerLevel.advanced => AppTheme.accent,
      SwimmerLevel.intermediate => const Color(0xFF58A6FF),
      SwimmerLevel.beginner => AppTheme.textSecondary,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: _levelColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _levelColor.withValues(alpha: 0.4)),
      ),
      child: Text(
        level.label,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: _levelColor,
          letterSpacing: 1,
        ),
      ),
    );
  }
}
