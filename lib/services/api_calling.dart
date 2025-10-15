import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:link_learner/core/utils/session_manager.dart';
import 'package:link_learner/services/api_service.dart';

late FirebaseMessaging _messaging;

class ApiCalling {
  final ApiService _api = ApiService();
  final SessionManager _sessionManager = SessionManager();

  ApiCalling() {
    _messaging = FirebaseMessaging.instance;
  }
}
