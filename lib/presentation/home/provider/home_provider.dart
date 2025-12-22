import 'package:flutter/material.dart';
import 'package:link_learner/core/constants/api_endpoint.dart';
import 'package:link_learner/core/utils/session_manager.dart';
import 'package:link_learner/presentation/home/model/dashboard_model.dart';
import 'package:link_learner/services/api_calling.dart';
import 'package:link_learner/services/api_service.dart';

import '../../profile/model/get_user_profile_model.dart' show ProfileResponse;

class HomeProvider extends ChangeNotifier {
  bool isLoading = false;
  final ApiService _api = ApiService();
  final SessionManager _sessionManager = SessionManager();

  DashboardResponse? dashboardResponse;
  ProfileResponse? profileResponse;

  Future<void> getDashboardStats() async {
    try {
      isLoading = true;
      notifyListeners();

      final res = await ApiCalling().getDashboardStats();

      // Assign full dashboard data
      dashboardResponse = res;
    } catch (e) {
      debugPrint("Dashboard Error: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> getProfile() async {
    try {
      isLoading = true;

      final response = await _api.get(ApiEndpoint.getProfile);
      profileResponse = ProfileResponse.fromJson(response);

      notifyListeners();
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
    }
  }
}
