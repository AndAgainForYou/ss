import 'package:flutter/material.dart';
import 'package:swim_success/app/theme.dart';
import 'package:swim_success/core/constants/pace_constants.dart';

class PaceSliderWidget extends StatelessWidget {
  const PaceSliderWidget({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Slider(
          value: value,
          min: PaceConstants.minTotalSeconds.toDouble(),
          max: PaceConstants.maxTotalSeconds.toDouble(),
          onChanged: onChanged,
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: PaceConstants.sliderTickSeconds.map((seconds) {
            return Text(
              PaceConstants.formatTime(seconds),
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondary,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
