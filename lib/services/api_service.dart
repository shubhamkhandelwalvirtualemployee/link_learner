import 'package:dio/dio.dart';
import 'package:link_learner/core/constants/api_urls.dart';
import 'package:link_learner/core/constants/session_constants.dart';
import 'package:link_learner/core/utils/session_manager.dart';

class ApiService {
  late final Dio _dio;
  // bool _isRefreshingToken = false;
  final SessionManager _sessionManager = SessionManager();

  ApiService() {
    String baseUrl = ApiUrls.baseUrl;

    BaseOptions options = BaseOptions(
      baseUrl: baseUrl,
      contentType: Headers.jsonContentType,
      headers: {'Accept': 'application/json'},
      responseType: ResponseType.json,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 10),
    );

    _dio = Dio(options);

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _sessionManager.getValue(
            SessionConstants.accessToken,
          );
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onResponse: (response, handler) async {
          return handler.next(response);
        },
        onError: (DioException error, handler) async {
          final statusCode = error.response?.statusCode;
          if (statusCode == 401 || statusCode == 403) {
            await SessionManager().clearAll();
            // await Provider.of<BottomNavBarProvider>(
            //   navigatorKey.currentContext!,
            //   listen: false,
            // ).reset(notify: false);
            // if (navigatorKey.currentState?.context != null) {
            //   AppRoutes.pushAndRemoveUntil(
            //     navigatorKey.currentContext!,
            //     RouteNames.onBoardingScreen,
            //     (Route<dynamic> route) => false,
            //   );
            // }

            return handler.reject(
              DioException(
                requestOptions: error.requestOptions,
                error:
                    error.response?.data is Map<String, dynamic>
                        ? (error.response?.data["message"] ?? "Unauthorized")
                        : "Unauthorized",
                type: error.type,
                response: error.response,
              ),
            );
          }

          String errorMessage = "Something went wrong. Please try again.";
          final data = error.response?.data;
          if (data is Map<String, dynamic>) {
            if (data["errors"] != null) {
              errorMessage = data["errors"].toString();
            } else if (data["message"] != null) {
              errorMessage = data["message"];
            }
          }

          return handler.reject(
            DioException(
              requestOptions: error.requestOptions,
              error: errorMessage,
              response: error.response,
              type: error.type,
            ),
          );
        },
      ),
    );
  }

  // GET
  Future<dynamic> get(String path, [Map<String, String>? headers]) async {
    try {
      final response = await _dio.get(path, options: Options(headers: headers));
      return response.data;
    } on DioException catch (e) {
      throw Exception(e.error ?? e.message ?? "Unknown error");
    }
  }

  // POST
  Future<dynamic> post(
    String path,
    dynamic data, {
    Map<String, String>? headers,
    ProgressCallback? onSendProgress,
  }) async {
    try {
      Options options = Options(
        headers: headers,
        contentType:
            (data is FormData)
                ? Headers.multipartFormDataContentType
                : Headers.jsonContentType,
      );

      final response = await _dio.post(
        path,
        data: data,
        options: options,
        onSendProgress: onSendProgress,
      );

      return response.data;
    } on DioException catch (e) {
      throw Exception(e.error ?? e.message ?? "Unknown error");
    }
  }

  // PUT
  Future<dynamic> put(
    String path,
    dynamic data, {
    Map<String, String>? headers,
    ProgressCallback? onSendProgress,
  }) async {
    try {
      Options options = Options(
        headers: headers,
        contentType:
            (data is FormData)
                ? Headers.multipartFormDataContentType
                : Headers.jsonContentType,
      );

      final response = await _dio.put(
        path,
        data: data,
        options: options,
        onSendProgress: onSendProgress,
      );

      return response.data;
    } on DioException catch (e) {
      throw Exception(e.error ?? e.message ?? "Unknown error");
    }
  }

  // DELETE
  Future<dynamic> delete(String path, [Map<String, String>? headers]) async {
    try {
      final response = await _dio.delete(
        path,
        options: Options(headers: headers),
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception(e.error ?? e.message ?? "Unknown error");
    }
  }

  // PATCH
  Future<dynamic> patch(
    String path,
    dynamic data, [
    Map<String, String>? headers,
  ]) async {
    try {
      final response = await _dio.patch(
        path,
        data: data,
        options: Options(headers: headers),
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception(e.error ?? e.message ?? "Unknown error");
    }
  }
}
