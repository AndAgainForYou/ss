import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swim_success/core/network/api_client.dart';
import 'package:swim_success/features/users/data/users_repository.dart';
import 'package:swim_success/features/users/presentation/cubit/users_state.dart';

class UsersCubit extends Cubit<UsersState> {
  UsersCubit(this._repository) : super(const UsersInitial());

  final UsersRepository _repository;

  Future<void> fetchUsers() async {
    emit(const UsersLoading());
    try {
      final users = await _repository.fetchUsers();
      emit(UsersLoaded(allUsers: users, filteredUsers: users));
    } on ApiException catch (e) {
      emit(UsersError(e.message));
    } catch (_) {
      emit(const UsersError('Network error. Please check your connection.'));
    }
  }

  void search(String query) {
    final current = state;
    if (current is! UsersLoaded) return;

    final trimmed = query.trim();
    final filtered = trimmed.isEmpty
        ? current.allUsers
        : current.allUsers
            .where(
              (u) => u.name.toLowerCase().contains(trimmed.toLowerCase()),
            )
            .toList();

    emit(current.copyWith(filteredUsers: filtered, searchQuery: query));
  }
}
