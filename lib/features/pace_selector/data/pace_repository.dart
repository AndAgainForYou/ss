import 'package:swim_success/core/network/api_client.dart';

class PaceRepository {
  PaceRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<void> submitPace(int paceSeconds) async {
    await _apiClient.post('/posts', body: {'pace_seconds': paceSeconds});
  }
}
