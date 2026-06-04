import 'package:dio/dio.dart';

import '../../utils/logger.dart';
import 'api.end.points.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();

  factory DioClient() => _instance;

  late Dio dio;

  DioClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiEndPoints.baseAPIUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          "Accept": "application/json",
        },
      ),
    );

    _initializeInterceptors();
  }

  void _initializeInterceptors() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add auth token dynamically (if needed)

          // String? token = await SecureStorage().getToken();

          // if (token != null) {
          //   options.headers["Authorization"] = "Bearer $token";
          // }

          logger("➡️ REQUEST: ${options.method} ${options.path}");
          logger("Headers: ${options.headers}");
          logger("Data: ${options.data}");

          return handler.next(options);
        },
        onResponse: (response, handler) {
          logger(" RESPONSE: ${response.statusCode}");
          logger("Data: ${response.data}");

          return handler.next(response);
        },
        onError: (DioException e, handler) async {
          logger("ERROR: ${e.response?.statusCode}");
          logger("Message: ${e.message}");

          // Handle token expiry (401)
          if (e.response?.statusCode == 401) {
            // TODO: refresh token or logout
          }

          return handler.next(e);
        },
      ),
    );
  }

  // GET METHOD
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? headers,
  }) async {
    return dio.get(
      path,
      queryParameters: queryParams,
      options: Options(headers: headers),
    );
  }

  // POST METHOD
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? headers,
    bool isFormData = false,
  }) async {
    return dio.post(
      path,
      data: isFormData ? FormData.fromMap(data) : data,
      queryParameters: queryParams,
      options: Options(
        headers: headers,
        contentType: isFormData
            ? Headers.formUrlEncodedContentType
            : Headers.jsonContentType,
      ),
    );
  }
}
