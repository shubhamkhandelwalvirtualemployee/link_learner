import 'package:flutter/material.dart';

class BottomNavProvider extends ChangeNotifier {
  int _selectedIndex = 1;

  int get selectedIndex => _selectedIndex;

  void onItemTapped(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  String getAppBarTitle() {
    switch (_selectedIndex) {
      case 1:
        return 'Booking';
      default:
        return [
          'Home',
          'Booking',
          'Booking & Search',
          'Notifications',
          'Account',
        ][_selectedIndex];
    }
  }

  bool get showProfileIcon => _selectedIndex == 1 || _selectedIndex == 2;
}
