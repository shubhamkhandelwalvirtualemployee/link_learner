import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:link_learner/core/constants/api_endpoint.dart';
import 'package:link_learner/core/constants/session_constants.dart';
import 'package:link_learner/core/utils/session_manager.dart';
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
}
