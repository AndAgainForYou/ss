import 'package:swim_success/features/users/data/models/user.dart';

sealed class UsersState {
  const UsersState();
}

final class UsersInitial extends UsersState {
  const UsersInitial();
}

final class UsersLoading extends UsersState {
  const UsersLoading();
}

final class UsersLoaded extends UsersState {
  const UsersLoaded({
    required this.allUsers,
    required this.filteredUsers,
    this.searchQuery = '',
  });

  final List<User> allUsers;
  final List<User> filteredUsers;
  final String searchQuery;

  UsersLoaded copyWith({
    List<User>? allUsers,
    List<User>? filteredUsers,
    String? searchQuery,
  }) {
    return UsersLoaded(
      allUsers: allUsers ?? this.allUsers,
      filteredUsers: filteredUsers ?? this.filteredUsers,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

final class UsersError extends UsersState {
  const UsersError(this.message);

  final String message;
}
