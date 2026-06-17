import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swim_success/app/theme.dart';
import 'package:swim_success/core/di/injection.dart';
import 'package:swim_success/features/pace_selector/data/pace_repository.dart';
import 'package:swim_success/features/pace_selector/presentation/cubit/pace_cubit.dart';
import 'package:swim_success/features/pace_selector/presentation/pace_selector_screen.dart';
import 'package:swim_success/features/users/data/users_repository.dart';
import 'package:swim_success/features/users/presentation/cubit/users_cubit.dart';
import 'package:swim_success/features/users/presentation/users_list_screen.dart';

class SwimSuccessApp extends StatelessWidget {
  const SwimSuccessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => PaceCubit(sl<PaceRepository>()),
        ),
        BlocProvider(
          create: (_) => UsersCubit(sl<UsersRepository>())..fetchUsers(),
        ),
      ],
      child: MaterialApp(
        title: 'Swim Success',
        theme: AppTheme.darkTheme,
        home: const _HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class _HomeScreen extends StatefulWidget {
  const _HomeScreen();

  @override
  State<_HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<_HomeScreen> {
  int _currentIndex = 0;

  static const _screens = [
    PaceSelectorScreen(),
    UsersListScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        backgroundColor: AppTheme.surface,
        indicatorColor: AppTheme.accent.withValues(alpha: 0.2),
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.timer_outlined),
            selectedIcon: Icon(Icons.timer),
            label: 'Pace',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Users',
          ),
        ],
      ),
    );
  }
}
