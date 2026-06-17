import 'package:hive/hive.dart';
import 'package:swim_success/core/network/api_client.dart';
import 'package:swim_success/features/users/data/models/user.dart';

class UsersRepository {
  UsersRepository({required ApiClient apiClient, required Box<User> box})
      : _apiClient = apiClient,
        _box = box;

  final ApiClient _apiClient;
  final Box<User> _box;

  Future<List<User>> fetchUsers() async {
    try {
      final data = await _apiClient.get('/users');
      final users = data
          .map((json) => User.fromJson(json as Map<String, dynamic>))
          .toList();

      await _box.clear();
      await _box.putAll({for (final u in users) u.id: u});

      return users;
    } on ApiException {
      final cached = _box.values.toList();
      if (cached.isNotEmpty) return cached;
      rethrow;
    }
  }
}
