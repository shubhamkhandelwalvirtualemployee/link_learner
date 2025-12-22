import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:link_learner/core/constants/api_endpoint.dart';
import 'package:link_learner/core/constants/api_urls.dart';
import 'package:link_learner/core/constants/route_names.dart';
import 'package:link_learner/core/constants/session_constants.dart';
import 'package:link_learner/core/utils/session_manager.dart';
import 'package:link_learner/routes/app_routes.dart';

class ApiService {
  late final Dio _dio;
  final SessionManager _sessionManager = SessionManager();
  bool _isRefreshing = false;
  final List<Function()> _pendingRequests = [];
  bool _hasLoggedOut = false;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

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
            final requestPath = error.requestOptions.path;

            // ❌ Login API → don't refresh
            if (requestPath.contains(ApiEndpoint.login)) {
              return handler.reject(error);
            }

            // 🔒 IF refresh already in progress → QUEUE request
            if (_isRefreshing) {
              final completer = Completer<Response>();

              _pendingRequests.add(() async {
                try {
                  final newToken = await _sessionManager.getValue(
                    SessionConstants.accessToken,
                  );

                  error.requestOptions.headers['Authorization'] =
                      'Bearer $newToken';

                  final retryResponse = await _dio.fetch(error.requestOptions);
                  completer.complete(retryResponse);
                } catch (e) {
                  completer.completeError(e);
                }
              });

              return completer.future
                  .then(handler.resolve)
                  .catchError(handler.reject);
            }

            // 🚀 START refresh
            _isRefreshing = true;

            try {
              final refreshed = await _refreshToken();

              if (!refreshed) {
                await _forceLogout();
                return handler.reject(error);
              }
              final queuedRequests = List<Function()>.from(_pendingRequests);
              _pendingRequests.clear();

              for (final retry in queuedRequests) {
                retry();
              }

              // 🔁 Retry current request
              final newToken = await _sessionManager.getValue(
                SessionConstants.accessToken,
              );

              error.requestOptions.headers['Authorization'] =
                  'Bearer $newToken';

              final retryResponse = await _dio.fetch(error.requestOptions);
              return handler.resolve(retryResponse);
            } catch (e) {
              await _forceLogout();
              return handler.reject(error);
            } finally {
              _isRefreshing = false;
            }
          }

          // ---------------- OTHER ERRORS ----------------
          String errMsg = "Something went wrong. Please try again.";

          final data = error.response?.data;
          if (data is Map<String, dynamic>) {
            errMsg = data["message"] ?? data["errors"]?.toString() ?? errMsg;
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

  Future<void> _forceLogout() async {
    if (_hasLoggedOut) return;
    _hasLoggedOut = true;

    await _sessionManager.clearAll();

    AppRoutes.pushAndRemoveUntil(
      navigatorKey.currentContext!,
      RouteNames.loginScreen,
      (route) => false,
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
  Future<dynamic> post(String path, dynamic data) async {
    try {
      dynamic requestBody;
      bool isMultipart = false;

      // -----------------------------------------------------
      // CASE 1: Caller already passed FormData
      // -----------------------------------------------------
      if (data is FormData) {
        requestBody = data;
        isMultipart = true;
      }
      // -----------------------------------------------------
      // CASE 2: Caller passed a Map (dynamic or typed)
      // -----------------------------------------------------
      else if (data is Map) {
        // Convert dynamic map to <String, dynamic>
        final Map<String, dynamic> fixedMap = data.map(
          (key, value) => MapEntry(key.toString(), value),
        );

        // Prepare new processed map
        final processed = <String, dynamic>{};

        for (final entry in fixedMap.entries) {
          if (entry.value is File) {
            isMultipart = true;
            processed[entry.key] = await MultipartFile.fromFile(
              (entry.value as File).path,
              filename: (entry.value as File).path.split('/').last,
            );
          } else {
            processed[entry.key] = entry.value;
          }
        }

        requestBody = isMultipart ? FormData.fromMap(processed) : processed;
      }
      // -----------------------------------------------------
      // CASE 3: Unknown type (not allowed)
      // -----------------------------------------------------
      else {
        throw Exception("🚫 Unsupported POST body type: ${data.runtimeType}");
      }

      // -----------------------------------------------------
      // DEBUG LOG
      // -----------------------------------------------------
      print("🔥 FINAL BODY SENT TO SERVER:");

      if (requestBody is FormData) {
        for (var f in requestBody.fields) {
          print("Field: ${f.key} = ${f.value}");
        }
        for (var f in requestBody.files) {
          print("File: ${f.key} => ${f.value.filename}");
        }
      } else {
        print(requestBody);
      }

      // -----------------------------------------------------
      // SEND REQUEST
      // -----------------------------------------------------
      final response = await _dio.post(
        path,
        data: requestBody,
        options: Options(
          contentType:
              isMultipart
                  ? Headers.multipartFormDataContentType
                  : Headers.jsonContentType,
        ),
      );

      if (response.data is String &&
          response.data.startsWith("<!DOCTYPE html")) {
        throw Exception("Invalid response — received HTML instead of JSON");
      }

      return response.data;
    } on DioException catch (e) {
      print("❗ POST Error Response: ${e.response?.data}");
      throw Exception(e.response?.data ?? e.message ?? "Unknown POST error");
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
    final refreshToken = await _sessionManager.getValue(
      SessionConstants.refreshToken,
    );

    if (refreshToken == null) return false;

    try {
      final dio = Dio(
        BaseOptions(
          baseUrl: ApiUrls.baseUrl,
          contentType: Headers.jsonContentType,
        ),
      );

      final res = await dio.post(
        ApiEndpoint.refreshToken,
        data: {"refreshToken": refreshToken},
      );

      final newAccess = res.data["data"]["accessToken"];
      final newRefresh = res.data["data"]["refreshToken"];

      if (newAccess != null) {
        await _sessionManager.setValue(SessionConstants.accessToken, newAccess);
      }
      if (newRefresh != null) {
        await _sessionManager.setValue(
          SessionConstants.refreshToken,
          newRefresh,
        );
      }

      return true;
    } catch (_) {
      return false;
    }
  }
}
