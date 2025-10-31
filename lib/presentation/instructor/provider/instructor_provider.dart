import 'package:flutter/cupertino.dart';
import 'package:link_learner/presentation/instructor/model/instructor_detail_response.dart';
import 'package:link_learner/presentation/instructor/model/intructor_list_model.dart';
import 'package:link_learner/presentation/instructor/model/weekly_available_model.dart';
import 'package:link_learner/services/api_calling.dart';

class InstructorProvider extends ChangeNotifier {
  bool isLoading = false;
  bool isPaginating = false;
  bool hasMore = true;

  int page = 1;
  final int limit = 10;

  InstructorListResponse? instructorListResponse;
  String searchText = "";
  WeeklyAvailabilityResponse? weeklyAvailability;
  InstructorDetailResponse? instructorDetailResponse;
  bool isAvailabilityLoading = false;

  Future<void> getInstructorList({bool isRefresh = false}) async {

    if (isRefresh) {
      page = 1;
      hasMore = true;
      instructorListResponse = null;   // ✅ reset old data
    }

    if ((isPaginating && !isRefresh) || !hasMore) return;

    if (page == 1) {
      isLoading = true;
    } else {
      isPaginating = true;
    }
    notifyListeners();

    try {
      final res = await ApiCalling().getInstructorList(
        page: page,
        limit: limit,
        search: searchText.trim().isEmpty ? null : searchText.trim(),
      );

      if (page == 1) {
        instructorListResponse = res; // ✅ fresh list
      } else {
        instructorListResponse!.data!.instructors!
            .addAll(res.data?.instructors ?? []);
      }

      // ✅ pagination condition:
      hasMore = (res.data?.instructors?.length ?? 0) == limit;

      if (hasMore) {
        page++;
      }

    } catch (e) {
      debugPrint("Pagination Error: $e");
    }

    isLoading = false;
    isPaginating = false;
    notifyListeners();
  }



  Future<void> getWeeklyAvailabilityProvider(String instructorId) async {
    isAvailabilityLoading = true;
    notifyListeners();

    try {
      final res =
      await ApiCalling().getWeeklyAvailability(instructorId);

      weeklyAvailability = res;   // ✅ store data

    } catch (e) {
      debugPrint("Error fetching weekly availability: $e");
    }

    isAvailabilityLoading = false;
    notifyListeners();
  }

  Future<void> getInstructorDetailProvider(String instructorId) async {
    notifyListeners();

    try {
      final res = await ApiCalling().getInstructorDetails(instructorId);
      instructorDetailResponse = res;
    } catch (e) {
      debugPrint("Error fetching instructor detail: $e");
    }

    isAvailabilityLoading = false;
    notifyListeners();
  }


}
