import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swim_success/app/theme.dart';
import 'package:swim_success/features/pace_selector/presentation/cubit/pace_cubit.dart';
import 'package:swim_success/features/pace_selector/presentation/cubit/pace_state.dart';
import 'package:swim_success/features/pace_selector/presentation/widgets/pace_input_widget.dart';
import 'package:swim_success/features/pace_selector/presentation/widgets/pace_slider_widget.dart';
import 'package:swim_success/features/pace_selector/presentation/widgets/swimmer_level_badge.dart';

class PaceSelectorScreen extends StatelessWidget {
  const PaceSelectorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pace Selector')),
      body: SafeArea(
        child: BlocBuilder<PaceCubit, PaceState>(
          builder: (context, state) {
            final cubit = context.read<PaceCubit>();

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 32),
                        const Text(
                          'Fastest 100m Freestyle',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 24),
                        PaceInputWidget(
                          minutes: state.minutes,
                          seconds: state.seconds,
                          onMinutesChanged: cubit.setMinutes,
                          onSecondsChanged: cubit.setSeconds,
                          onIncrementMinutes: cubit.incrementMinutes,
                          onDecrementMinutes: cubit.decrementMinutes,
                          onIncrementSeconds: cubit.incrementSeconds,
                          onDecrementSeconds: cubit.decrementSeconds,
                        ),
                        const SizedBox(height: 32),
                        SwimmerLevelBadge(level: state.level),
                        const SizedBox(height: 48),
                        PaceSliderWidget(
                          value: state.totalSeconds.toDouble(),
                          onChanged: (v) => cubit.setTotalSeconds(v.round()),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
                _SubmitSection(state: state, cubit: cubit),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SubmitSection extends StatelessWidget {
  const _SubmitSection({required this.state, required this.cubit});

  final PaceState state;
  final PaceCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (state.errorMessage != null) ...[
            Text(
              state.errorMessage!,
              style: const TextStyle(color: AppTheme.error),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
          ],
          if (state.successMessage != null) ...[
            Text(
              state.successMessage!,
              style: const TextStyle(color: AppTheme.accent),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
          ],
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton(
              onPressed: state.isSubmitting ? null : cubit.submitPace,
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.accent,
                foregroundColor: AppTheme.background,
                disabledBackgroundColor:
                    AppTheme.accent.withValues(alpha: 0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: state.isSubmitting
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppTheme.background,
                      ),
                    )
                  : const Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
