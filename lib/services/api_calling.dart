import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:link_learner/core/constants/api_endpoint.dart';
import 'package:link_learner/core/constants/session_constants.dart';
import 'package:link_learner/core/utils/session_manager.dart';
import 'package:link_learner/presentation/checkout/model/calculate_price_model.dart';
import 'package:link_learner/presentation/checkout/model/check_availablity_model.dart';
import 'package:link_learner/presentation/checkout/model/create_booking_model.dart';
import 'package:link_learner/presentation/checkout/model/paymnet_intent_model.dart';
import 'package:link_learner/presentation/instructor/model/instructor_detail_response.dart';
import 'package:link_learner/presentation/instructor/model/instructor_package_model.dart';
import 'package:link_learner/presentation/instructor/model/intructor_list_model.dart';
import 'package:link_learner/presentation/instructor/model/weekly_available_model.dart';
import 'package:link_learner/presentation/login_signup/model/login_response_model.dart';
import 'package:link_learner/presentation/login_signup/model/sign_up_request_model.dart';
import 'package:link_learner/presentation/login_signup/model/sign_up_response_model.dart';
import 'package:link_learner/presentation/profile/model/payment_history_response.dart';
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
      final refreshToken = response["data"]['refreshToken'];

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
      if (refreshToken != null) {
        await _sessionManager.setValue(
          SessionConstants.refreshToken,
          refreshToken,
        );
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

  Future<dynamic> logout({String? refreshToken}) async {
    try {
      final response = await _api.post(ApiEndpoint.logout,{
        "refreshToken": refreshToken
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
      final refreshToken = response["data"]['refreshToken'];

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
      if (refreshToken != null) {
        await _sessionManager.setValue(
          SessionConstants.refreshToken,
          refreshToken,
        );
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
    String? county,
    String? sortBy,
    String? minRate,
    String? maxRate,
    String? minRating,
  }) async {
    try {
      final queryParams = [
        "page=$page",
        "limit=$limit",
        if (search != null && search.isNotEmpty) "search=$search",
        if (county != null && county.isNotEmpty) "county=$county",
        if (sortBy != null && sortBy.isNotEmpty) "sortBy=$sortBy",
        if (minRate != null && minRate.isNotEmpty) "minRate=$minRate",
        if (maxRate != null && maxRate.isNotEmpty) "maxRate=$maxRate",
        if (minRating != null && minRating.isNotEmpty) "minRating=$minRating",
      ].join("&");
      print("${ApiEndpoint.instructorList}}?$queryParams");

      final response = await _api.get("${ApiEndpoint.instructorList}");
      //final response = await _api.get("${ApiEndpoint.instructorList}?$queryParams");

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

  Future<InstructorPackagesResponse> getInstructorPackage(
      String instructorId) async {
    final res = await _api.get(
      "/v1/instructors/$instructorId/packages",
    );

    return InstructorPackagesResponse.fromJson(res);
  }

  Future<InstructorDetailResponse> getInstructorDetails(
      String instructorId) async {
    final res = await _api.get(
      "/v1/instructors/$instructorId",
    );
    return InstructorDetailResponse.fromJson(res);
  }

  Future<CalculatePriceResponse> calculatePrice({
    required String instructorId,
    required String selectedDate,
    required int duration,
  }) async {
    try {
      final response = await _api.post(ApiEndpoint.calculatePrice, {
          "instructorId": instructorId,
          "scheduledAt": selectedDate,
          "duration": 60

      });
      return CalculatePriceResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<CreateBookingResponse> createBooking({
    required String instructorId,
    required String scheduledAt,
    required int duration,
    required String location,
    required String notes,
    bool usePackageCredit = false,
  }) async {
    try {

      final response = await _api.post(
        ApiEndpoint.createBooking,   // "/v1/bookings"
          {
            "instructorId": instructorId,
            "scheduledAt": scheduledAt,
            "duration": duration,
            "location": location,
            "notes": notes,
            "usePackageCredit": usePackageCredit,
          }
      );

      return CreateBookingResponse.fromJson(response);
    } catch (e) {
      throw Exception("Create Booking Error: $e");
    }
  }

  Future<PaymentIntentResponse> createPaymentIntentForBooking({
    required String bookingId,
  }) async {
    try {

      final response = await _api.post(
        ApiEndpoint.paymentForBooking,   // "/v1/payments/booking"
          {"bookingId": bookingId}
      );
      return PaymentIntentResponse.fromJson(response);
    } catch (e) {
      throw Exception("Payment Intent Error: $e");
    }
  }

  Future<PaymentHistoryResponse> getPaymentHistory() async {
    final response = await _api.get(ApiEndpoint.paymentHistory);
    print(response);
    return PaymentHistoryResponse.fromJson(response);
  }
  Future<CheckAvailabilityResponse> checkAvailability({
    required String instructorId,
    required String scheduledAt,
    required int duration,
  }) async {
    try {
      final response = await _api.post(
        ApiEndpoint.checkAvailability,
        {
          "instructorId": instructorId,
          "scheduledAt": scheduledAt,
          "duration": duration,
        },
      );
      print(response);

      return CheckAvailabilityResponse.fromJson(response);
    } catch (e) {
      print("❌ Error checking availability: $e");
      rethrow;
    }
  }


}
