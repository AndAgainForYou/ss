import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:swim_success/app/theme.dart';

class PaceInputWidget extends StatelessWidget {
  const PaceInputWidget({
    super.key,
    required this.minutes,
    required this.seconds,
    required this.onMinutesChanged,
    required this.onSecondsChanged,
    required this.onIncrementMinutes,
    required this.onDecrementMinutes,
    required this.onIncrementSeconds,
    required this.onDecrementSeconds,
  });

  final int minutes;
  final int seconds;
  final ValueChanged<int> onMinutesChanged;
  final ValueChanged<int> onSecondsChanged;
  final VoidCallback onIncrementMinutes;
  final VoidCallback onDecrementMinutes;
  final VoidCallback onIncrementSeconds;
  final VoidCallback onDecrementSeconds;

  Future<void> _showEditDialog(
    BuildContext context, {
    required String label,
    required int currentValue,
    required int maxValue,
    required ValueChanged<int> onChanged,
  }) async {
    final controller = TextEditingController(text: currentValue.toString());
    final result = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: Text('Edit $label'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          autofocus: true,
          style: const TextStyle(color: AppTheme.textPrimary, fontSize: 24),
          decoration: const InputDecoration(hintText: '0'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final value = int.tryParse(controller.text) ?? currentValue;
              Navigator.pop(context, value.clamp(0, maxValue));
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );

    if (result != null) {
      onChanged(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _TimeColumn(
          value: minutes,
          label: 'MIN',
          maxValue: 3,
          onIncrement: onIncrementMinutes,
          onDecrement: onDecrementMinutes,
          onTap: () => _showEditDialog(
            context,
            label: 'Minutes',
            currentValue: minutes,
            maxValue: 3,
            onChanged: onMinutesChanged,
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            ':',
            style: TextStyle(
              fontSize: 64,
              fontWeight: FontWeight.w300,
              color: AppTheme.textPrimary,
            ),
          ),
        ),
        _TimeColumn(
          value: seconds,
          label: 'SEC',
          maxValue: 59,
          onIncrement: onIncrementSeconds,
          onDecrement: onDecrementSeconds,
          onTap: () => _showEditDialog(
            context,
            label: 'Seconds',
            currentValue: seconds,
            maxValue: 59,
            onChanged: onSecondsChanged,
          ),
        ),
      ],
    );
  }
}

class _TimeColumn extends StatelessWidget {
  const _TimeColumn({
    required this.value,
    required this.label,
    required this.maxValue,
    required this.onIncrement,
    required this.onDecrement,
    required this.onTap,
  });

  final int value;
  final String label;
  final int maxValue;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ArrowButton(icon: Icons.keyboard_arrow_up, onPressed: onIncrement),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: onTap,
          child: Column(
            children: [
              Text(
                value.toString().padLeft(2, '0'),
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        _ArrowButton(icon: Icons.keyboard_arrow_down, onPressed: onDecrement),
      ],
    );
  }
}

class _ArrowButton extends StatelessWidget {
  const _ArrowButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon, color: AppTheme.accent, size: 32),
      splashRadius: 24,
    );
  }
}
