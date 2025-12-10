import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:link_learner/core/constants/api_urls.dart';
import 'package:link_learner/core/constants/route_names.dart';
import 'package:link_learner/core/constants/session_constants.dart';
import 'package:link_learner/core/utils/session_manager.dart';
import 'package:link_learner/main.dart';
import 'package:link_learner/routes/app_routes.dart';

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
          // ✅ Normalize backend responses
          final data = response.data;

          // If response is just a boolean (true/false)
          if (data is bool) {
            response.data = {
              "success": data,
              "message": data ? "Request successful" : "Request failed",
            };
          }
          // Optional: if you want to wrap plain string responses
          else if (data is String) {
            response.data = {"success": true, "message": data};
          }

          return handler.next(response);
        },
        onError: (DioException error, handler) async {
          final statusCode = error.response?.statusCode;
          print("satus code$statusCode");

          // ---------------- TOKEN EXPIRED LOGIC ----------------
          if (statusCode == 401) {
            final refreshed = await _refreshToken();

            if (refreshed) {
              // Retry original request with the new token
              final newToken =
              await _sessionManager.getValue(SessionConstants.accessToken);

              final RequestOptions requestOptions = error.requestOptions;
              requestOptions.headers["Authorization"] = "Bearer $newToken";

              final retryResponse = await _dio.request(
                requestOptions.path,
                data: requestOptions.data,
                queryParameters: requestOptions.queryParameters,
                options: Options(
                  method: requestOptions.method,
                  headers: requestOptions.headers,
                ),
              );

              return handler.resolve(retryResponse);
            }

            // Refresh FAILED → Force logout
            await SessionManager().clearAll();

            AppRoutes.pushAndRemoveUntil(
              navigatorKey.currentContext!,
              RouteNames.loginScreen,
                  (Route<dynamic> route) => false,
            );

            return handler.reject(
              DioException(
                requestOptions: error.requestOptions,
                error: "Session expired. Please log in again.",
              ),
            );
          }

          // ---------------- OTHER ERRORS ----------------
          String errMsg = "Something went wrong. Please try again.";

          final data = error.response?.data;
          if (data is Map<String, dynamic>) {
            errMsg = data["message"] ??
                data["errors"]?.toString() ??
                errMsg;
          }

          return handler.reject(
            DioException(
              requestOptions: error.requestOptions,
              error: errMsg,
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

  Future<bool> _refreshToken() async {
    final refreshToken =
    await _sessionManager.getValue(SessionConstants.refreshToken);

    if (refreshToken == null) return false;

    try {
      final res = await _dio.post(
        "/v1/auth/refresh",
        data: {
          "refreshToken": refreshToken, // ← sent in request body
        },
      );
      print(res);

      final newAccess = res.data["data"]["accessToken"];
      final newRefresh = res.data["data"]["refreshToken"];

      if (newAccess != null) {
        await _sessionManager.setValue(SessionConstants.accessToken, newAccess);
      }
      if (newRefresh != null) {
        await _sessionManager.setValue(SessionConstants.refreshToken, newRefresh);
      }
      print("djfvndfm");
      return true;
    } catch (e) {
      return false;
    }
  }

}
