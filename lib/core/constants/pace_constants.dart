/// Pace selector configuration and swimmer level thresholds.
abstract final class PaceConstants {
  static const int minTotalSeconds = 60;
  static const int maxTotalSeconds = 180;
  static const int defaultTotalSeconds = 97;

  static const int maxMinutes = 3;
  static const int maxSeconds = 59;

  static const int debounceMs = 500;

  static const List<int> sliderTickSeconds = [70, 90, 120];

  static String formatTime(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}

enum SwimmerLevel {
  elite('Elite'),
  advanced('Advanced'),
  intermediate('Intermediate'),
  beginner('Beginner');

  const SwimmerLevel(this.label);
  final String label;

  static SwimmerLevel fromSeconds(int totalSeconds) {
    if (totalSeconds < 70) return SwimmerLevel.elite;
    if (totalSeconds < 90) return SwimmerLevel.advanced;
    if (totalSeconds < 120) return SwimmerLevel.intermediate;
    return SwimmerLevel.beginner;
  }
}
