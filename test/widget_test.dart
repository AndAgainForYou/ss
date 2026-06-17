import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swim_success/app/theme.dart';
import 'package:swim_success/features/pace_selector/data/pace_repository.dart';
import 'package:swim_success/features/pace_selector/presentation/cubit/pace_cubit.dart';
import 'package:swim_success/features/pace_selector/presentation/pace_selector_screen.dart';
import 'package:swim_success/features/pace_selector/presentation/widgets/swimmer_level_badge.dart';
import 'package:swim_success/core/constants/pace_constants.dart';

// Fake repository avoids real network calls and DI setup in unit/widget tests.
class _FakePaceRepository implements PaceRepository {
  bool submitCalled = false;

  @override
  Future<void> submitPace(int paceSeconds) async {
    submitCalled = true;
  }

}

Widget _buildTestApp(Widget child) {
  return MaterialApp(theme: AppTheme.darkTheme, home: child);
}

void main() {
  group('PaceSelectorScreen', () {
    late _FakePaceRepository repo;
    late PaceCubit cubit;

    setUp(() {
      repo = _FakePaceRepository();
      cubit = PaceCubit(repo);
    });

    tearDown(() => cubit.close());

    testWidgets('renders title and initial state', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          BlocProvider.value(
            value: cubit,
            child: const PaceSelectorScreen(),
          ),
        ),
      );

      expect(find.text('Pace Selector'), findsOneWidget);
      expect(find.text('Fastest 100m Freestyle'), findsOneWidget);
      expect(find.text('Continue'), findsOneWidget);
    });

    testWidgets('shows correct swimmer level badge', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          BlocProvider.value(
            value: cubit,
            child: const PaceSelectorScreen(),
          ),
        ),
      );

      // Default is 97s → Intermediate
      expect(find.byType(SwimmerLevelBadge), findsOneWidget);
      expect(find.text(SwimmerLevel.intermediate.label), findsOneWidget);
    });

    testWidgets('updates level badge when seconds change', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          BlocProvider.value(
            value: cubit,
            child: const PaceSelectorScreen(),
          ),
        ),
      );

      cubit.setTotalSeconds(75); // 70–89 → Advanced
      await tester.pump();

      expect(find.text(SwimmerLevel.advanced.label), findsOneWidget);
    });
  });

  group('PaceCubit', () {
    late PaceCubit cubit;
    late _FakePaceRepository repo;

    setUp(() {
      repo = _FakePaceRepository();
      cubit = PaceCubit(repo);
    });

    tearDown(() => cubit.close());

    test('initial state is default seconds', () {
      expect(cubit.state.totalSeconds, PaceConstants.defaultTotalSeconds);
    });

    test('setTotalSeconds clamps to valid range', () {
      cubit.setTotalSeconds(0);
      expect(cubit.state.totalSeconds, PaceConstants.minTotalSeconds);

      cubit.setTotalSeconds(9999);
      expect(cubit.state.totalSeconds, PaceConstants.maxTotalSeconds);
    });

    test('swimmer level is derived from totalSeconds', () {
      cubit.setTotalSeconds(75); // 70–89 → Advanced
      expect(cubit.state.level, SwimmerLevel.advanced);

      cubit.setTotalSeconds(150);
      expect(cubit.state.level, SwimmerLevel.beginner);
    });

    test('submitPace calls repository', () async {
      await cubit.submitPace();
      expect(repo.submitCalled, isTrue);
    });
  });
}
