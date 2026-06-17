import 'package:swim_success/core/constants/pace_constants.dart';

final class PaceState {
  const PaceState({
    required this.totalSeconds,
    this.isSubmitting = false,
    this.errorMessage,
    this.successMessage,
  });

  final int totalSeconds;
  final bool isSubmitting;
  final String? errorMessage;
  final String? successMessage;

  int get minutes => totalSeconds ~/ 60;
  int get seconds => totalSeconds % 60;
  SwimmerLevel get level => SwimmerLevel.fromSeconds(totalSeconds);

  PaceState copyWith({
    int? totalSeconds,
    bool? isSubmitting,
    String? errorMessage,
    String? successMessage,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return PaceState(
      totalSeconds: totalSeconds ?? this.totalSeconds,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      successMessage:
          clearSuccess ? null : (successMessage ?? this.successMessage),
    );
  }
}
