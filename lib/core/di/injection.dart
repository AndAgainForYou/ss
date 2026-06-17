import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:swim_success/core/network/api_client.dart';
import 'package:swim_success/features/pace_selector/data/pace_repository.dart';
import 'package:swim_success/features/users/data/models/user.dart';
import 'package:swim_success/features/users/data/users_repository.dart';

final sl = GetIt.instance;

Future<void> setupDependencies() async {
  await _initHive();
  _initDio();
  _initRepositories();
}

Future<void> _initHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(UserAddressAdapter());
  Hive.registerAdapter(UserCompanyAdapter());

  final usersBox = await Hive.openBox<User>('users');
  sl.registerSingleton<Box<User>>(usersBox);
}

void _initDio() {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiClient.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ),
  );
  sl.registerSingleton<Dio>(dio);
  sl.registerSingleton<ApiClient>(ApiClient(sl<Dio>()));
}

void _initRepositories() {
  sl.registerSingleton<PaceRepository>(
    PaceRepository(sl<ApiClient>()),
  );
  sl.registerSingleton<UsersRepository>(
    UsersRepository(apiClient: sl<ApiClient>(), box: sl<Box<User>>()),
  );
}
