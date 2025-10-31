import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:link_learner/core/constants/api_endpoint.dart';
import 'package:link_learner/core/constants/session_constants.dart';
import 'package:link_learner/core/utils/session_manager.dart';
import 'package:link_learner/presentation/instructor/model/instructor_detail_response.dart';
import 'package:link_learner/presentation/instructor/model/intructor_list_model.dart';
import 'package:link_learner/presentation/instructor/model/weekly_available_model.dart';
import 'package:link_learner/presentation/login_signup/model/login_response_model.dart';
import 'package:link_learner/presentation/login_signup/model/sign_up_request_model.dart';
import 'package:link_learner/presentation/login_signup/model/sign_up_response_model.dart';
import 'package:link_learner/services/api_service.dart';

// late FirebaseMessaging _messaging;

class ApiCalling {
  final ApiService _api = ApiService();
  final SessionManager _sessionManager = SessionManager();

  // ApiCalling() {
  //   _messaging = FirebaseMessaging.instance;
  // }

  Future<SignUpResponseModel> signUp(
    SignUpRequestModel signUpRequestModel,
  ) async {
    try {
      final response = await _api.post(
        ApiEndpoint.register,
        signUpRequestModel,
      );

      final accessToken = response["data"]['accessToken'];

      if (accessToken != null) {
        await _sessionManager.setValue(
          SessionConstants.accessToken,
          accessToken,
        );

        // // Get FCM token
        // String? firebaseToken = await _messaging.getToken();
        // if (firebaseToken != null) {
        //   await updateFirebaseToken(firebaseToken: firebaseToken);
        // }
      }
      return SignUpResponseModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> resetPassword({
    required String email,
  }) async {
    try {
      final response = await _api.post(ApiEndpoint.resetPassword, {
        "email": email,
        "callbackUrl": "http://localhost:3013",
      });
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final response = await _api.put(ApiEndpoint.changePassword, {
        "currentPassword": oldPassword,
        "newPassword": newPassword
      });
      return response;
    } catch (e) {
      rethrow;
    }
  }


  Future<LoginResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _api.post(ApiEndpoint.login, {
        "email": email,
        "password": password,
      });
      final accessToken = response["data"]['accessToken'];

      if (accessToken != null) {
        await _sessionManager.setValue(
          SessionConstants.accessToken,
          accessToken,
        );

        // Get FCM token
        // String? firebaseToken = await _messaging.getToken();
        // if (firebaseToken != null) {
        //   await updateFirebaseToken(firebaseToken: firebaseToken);
        // }
      }

      return LoginResponseModel.fromJson(response);
    } catch (e) {
      print("ebdckj$e");
      rethrow;
    }
  }

  Future<InstructorListResponse> getInstructorList({
    required int page,
    required int limit,
    String? search,
  }) async {
    try {
      final response = await _api.get(
        "${ApiEndpoint.instructorList}?page=$page&limit=$limit"
            "${search != null && search.isNotEmpty ? "&search=$search" : ""}",
      );

      return InstructorListResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<WeeklyAvailabilityResponse> getWeeklyAvailability(
      String instructorId) async {
    final res = await _api.get(
      "/v1/instructors/$instructorId/availability/weekly",
    );

    return WeeklyAvailabilityResponse.fromJson(res);
  }

  Future<InstructorDetailResponse> getInstructorDetails(
      String instructorId) async {
    final res = await _api.get(
      "/v1/instructors/$instructorId",
    );

    return InstructorDetailResponse.fromJson(res);
  }
}
