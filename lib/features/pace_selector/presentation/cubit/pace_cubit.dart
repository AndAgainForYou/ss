import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swim_success/core/constants/pace_constants.dart';
import 'package:swim_success/core/network/api_client.dart';
import 'package:swim_success/features/pace_selector/data/pace_repository.dart';
import 'package:swim_success/features/pace_selector/presentation/cubit/pace_state.dart';

class PaceCubit extends Cubit<PaceState> {
  PaceCubit(this._repository)
      : super(const PaceState(totalSeconds: PaceConstants.defaultTotalSeconds));

  final PaceRepository _repository;

  void setTotalSeconds(int totalSeconds) {
    final clamped = totalSeconds.clamp(
      PaceConstants.minTotalSeconds,
      PaceConstants.maxTotalSeconds,
    );
    emit(state.copyWith(
      totalSeconds: clamped,
      clearError: true,
      clearSuccess: true,
    ));
  }

  void setMinutes(int minutes) {
    setTotalSeconds(
      minutes.clamp(0, PaceConstants.maxMinutes) * 60 + state.seconds,
    );
  }

  void setSeconds(int seconds) {
    setTotalSeconds(
      state.minutes * 60 + seconds.clamp(0, PaceConstants.maxSeconds),
    );
  }

  void incrementMinutes() => setTotalSeconds(state.totalSeconds + 60);
  void decrementMinutes() => setTotalSeconds(state.totalSeconds - 60);
  void incrementSeconds() => setTotalSeconds(state.totalSeconds + 1);
  void decrementSeconds() => setTotalSeconds(state.totalSeconds - 1);

  Future<void> submitPace() async {
    if (state.isSubmitting) return;

    emit(state.copyWith(
      isSubmitting: true,
      clearError: true,
      clearSuccess: true,
    ));

    try {
      await _repository.submitPace(state.totalSeconds);
      emit(state.copyWith(
        isSubmitting: false,
        successMessage: 'Pace saved successfully!',
      ));
    } on ApiException catch (e) {
      emit(state.copyWith(isSubmitting: false, errorMessage: e.message));
    } catch (_) {
      emit(state.copyWith(
        isSubmitting: false,
        errorMessage: 'Network error. Please check your connection.',
      ));
    }
  }
}
