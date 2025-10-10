import 'package:flutter/material.dart';

class BookingSearchProvider extends ChangeNotifier {
  final List<String> categories = [
    'Design',
    'Painting',
    'Coding',
    'Music',
    'Visual identiy',
    'Mathmatics',
  ];
  String? selectedCategory;

  void selectCategory(String category) {
    selectedCategory = category;
    notifyListeners();
  }

  // --- Price Range ---
  RangeValues priceRange = const RangeValues(90, 200);
  final double minPrice = 0;
  final double maxPrice = 500;

  void updatePriceRange(RangeValues values) {
    priceRange = values;
    notifyListeners();
  }

  // --- Durations ---
  final List<String> durations = [
    '3-8 Hours',
    '8-14 Hours',
    '14-20 Hours',
    '20-24 Hours',
    '24-30 Hours',
  ];
  String? selectedDuration;

  void selectDuration(String duration) {
    selectedDuration = duration;
    notifyListeners();
  }

  // --- Clear All ---
  void clearFilters() {
    selectedCategory = null;
    selectedDuration = null;
    priceRange = const RangeValues(90, 200);
    notifyListeners();
  }

  final List<String> filterChips = ['All', 'Popular', 'New'];
  String _selectedChip = 'All';

  String get selectedChip => _selectedChip;

  void selectChip(String chip) {
    _selectedChip = chip;
    notifyListeners();
  }
}
