import 'package:dio/dio.dart';

class ApiException implements Exception {
  ApiException(this.message);
  final String message;

  @override
  String toString() => message;
}

class ApiClient {
  ApiClient(this._dio);

  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  final Dio _dio;

  Future<Map<String, dynamic>> post(
    String path, {
    required Map<String, dynamic> body,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(path, data: body);
      return response.data!;
    } on DioException catch (e) {
      throw ApiException(_dioErrorMessage(e));
    }
  }

  Future<List<dynamic>> get(String path) async {
    try {
      final response = await _dio.get<List<dynamic>>(path);
      return response.data!;
    } on DioException catch (e) {
      throw ApiException(_dioErrorMessage(e));
    }
  }

  static String _dioErrorMessage(DioException e) {
    if (e.response != null) {
      return 'Request failed (${e.response!.statusCode})';
    }
    return switch (e.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout =>
        'Connection timed out',
      DioExceptionType.connectionError => 'No internet connection',
      _ => e.message ?? 'Unknown network error',
    };
  }
}
