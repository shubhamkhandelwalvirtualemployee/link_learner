import 'package:flutter/cupertino.dart';
import 'package:link_learner/presentation/instructor/model/instructor_detail_response.dart';
import 'package:link_learner/presentation/instructor/model/instructor_package_model.dart';
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
  InstructorPackagesResponse? instructorPackagesResponse;
  bool isAvailabilityLoading = false;
  bool isInstructorPackageLoading = false;

  List<String> selectedSpecializations = [];

  void toggleSpecialization(String spec) {
    if (selectedSpecializations.contains(spec)) {
      selectedSpecializations.remove(spec);
    } else {
      selectedSpecializations.add(spec);
    }
    notifyListeners();
  }

  void clearSpecializations() {
    selectedSpecializations.clear();
    notifyListeners();
  }

  String selectedVehicle = '';
  String selectedVehicleType = '';

  void setSelectedVehicle(String vehicle) {
    selectedVehicle = vehicle;
    notifyListeners();
  }

  void setSelectedVehicleType(String type) {
    selectedVehicleType = type;
    notifyListeners();
  }

  AvailabilitySlot? selectedSlot;
  DateTime? selectedDate;
  DateTime? weekStartDate;

  void setSelectedDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }

  void setSelectedSlot(AvailabilitySlot slot) {
    selectedSlot = slot;
    notifyListeners();
  }
  void setWeekStartDate(DateTime date) {
    weekStartDate = date;
    notifyListeners();
  }


  String selectedCounty = "All Counties";
  String selectedRating = "Any Rating";
  String selectedSortBy = "Highest Rated";
  String minPrice = "";
  String maxPrice = "";
  String cityTown = "";

  void setSelectedCounty(String county) {
    selectedCounty = county;
    notifyListeners();
  }

  void setSelectedRating(String rating) {
    selectedRating = rating;
    notifyListeners();
  }

  void setSelectedSortBy(String sortBy) {
    selectedSortBy = sortBy;
    notifyListeners();
  }

  void setMinPrice(String value) {
    minPrice = value;
    notifyListeners();
  }

  void setMaxPrice(String value) {
    maxPrice = value;
    notifyListeners();
  }

  void setCityTown(String value) {
    cityTown = value;
    notifyListeners();
  }

  void clearAllFilters() {
    selectedCounty = "All Counties";
    selectedRating = "Any Rating";
    selectedSortBy = "Highest Rated";
    selectedVehicleType = "";
    selectedSpecializations.clear();
    minPrice = "";
    maxPrice = "";
    cityTown = "";
    notifyListeners();
  }


  Future<void> getInstructorList({bool isRefresh = false}) async {
    if (isRefresh) {
      page = 1;
      hasMore = true;
      instructorListResponse = null;
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
        county: selectedCounty,
        sortBy: selectedSortBy,
        minRate: minPrice,
        maxRate: maxPrice,
        minRating: selectedRating,
      );

      if (page == 1) {
        instructorListResponse = res;
      } else {
        instructorListResponse!.data!.instructors!.addAll(res.data?.instructors ?? []);
      }

      hasMore = (res.data?.instructors?.length ?? 0) == limit;
      if (hasMore) page++;
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

  Future<void> getInstructorPackage(String instructorId) async {
    isInstructorPackageLoading = true;
    notifyListeners();

    try {
      final res =
      await ApiCalling().getInstructorPackage(instructorId);

      instructorPackagesResponse = res;   // ✅ store data

    } catch (e) {
      debugPrint("Error fetching weekly availability: $e");
    }

    isInstructorPackageLoading = false;
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
