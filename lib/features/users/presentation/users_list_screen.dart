import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swim_success/app/theme.dart';
import 'package:swim_success/features/users/data/models/user.dart';
import 'package:swim_success/features/users/presentation/cubit/users_cubit.dart';
import 'package:swim_success/features/users/presentation/cubit/users_state.dart';
import 'package:swim_success/features/users/presentation/user_detail_screen.dart';

class UsersListScreen extends StatefulWidget {
  const UsersListScreen({super.key});

  @override
  State<UsersListScreen> createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _clearSearch() {
    _searchController.clear();
    context.read<UsersCubit>().search('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: () {
              _clearSearch();
              context.read<UsersCubit>().fetchUsers();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: BlocBuilder<UsersCubit, UsersState>(
              buildWhen: (prev, curr) =>
                  (curr is UsersLoaded) || (prev is UsersLoaded),
              builder: (context, state) {
                final query =
                    state is UsersLoaded ? state.searchQuery : '';
                return TextField(
                  controller: _searchController,
                  onChanged: context.read<UsersCubit>().search,
                  decoration: InputDecoration(
                    hintText: 'Search by name...',
                    hintStyle:
                        const TextStyle(color: AppTheme.textSecondary),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppTheme.textSecondary,
                    ),
                    suffixIcon: query.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 20),
                            onPressed: _clearSearch,
                          )
                        : null,
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<UsersCubit, UsersState>(
              builder: (context, state) => switch (state) {
                UsersInitial() || UsersLoading() => const Center(
                    child: CircularProgressIndicator(),
                  ),
                UsersError(:final message) => _ErrorView(
                    message: message,
                    onRetry: context.read<UsersCubit>().fetchUsers,
                  ),
                UsersLoaded(:final filteredUsers) => filteredUsers.isEmpty
                    ? const Center(
                        child: Text(
                          'No users found',
                          style: TextStyle(color: AppTheme.textSecondary),
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () async {
                          _clearSearch();
                          await context.read<UsersCubit>().fetchUsers();
                        },
                        color: AppTheme.accent,
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          itemCount: filteredUsers.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final user = filteredUsers[index];
                            return _UserCard(
                              user: user,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (_) =>
                                      UserDetailScreen(user: user),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _UserCard extends StatelessWidget {
  const _UserCard({required this.user, required this.onTap});

  final User user;
  final VoidCallback onTap;

  String get _initials {
    final parts = user.name.split(' ');
    return parts.length >= 2
        ? '${parts.first[0]}${parts.last[0]}'.toUpperCase()
        : user.name[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: AppTheme.accent.withValues(alpha: 0.2),
                foregroundColor: AppTheme.accent,
                child: Text(
                  _initials,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    _InfoRow(icon: Icons.email_outlined, text: user.email),
                    const SizedBox(height: 2),
                    _InfoRow(icon: Icons.phone_outlined, text: user.phone),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AppTheme.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppTheme.textSecondary),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              color: AppTheme.textSecondary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off,
              size: 48,
              color: AppTheme.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(color: AppTheme.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.accent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
