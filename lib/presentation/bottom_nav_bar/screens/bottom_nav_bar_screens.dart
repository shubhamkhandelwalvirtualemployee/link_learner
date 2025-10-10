import 'package:flutter/material.dart';
import 'package:link_learner/presentation/bottom_nav_bar/provider/bottom_nav_bar_provider.dart';
import 'package:link_learner/presentation/notifications/screens/notifications_tab_screen.dart';
import 'package:link_learner/presentation/booking/screens/booking_screen.dart';
import 'package:provider/provider.dart';
import 'package:link_learner/core/constants/color_constants.dart';

import 'package:link_learner/presentation/booking_and_search/screens/booking_search_screen.dart';
import 'package:link_learner/presentation/home/screen/home_screen.dart';
import 'package:link_learner/presentation/profile/screens/profile_screen.dart';

class BottomNavBarScreens extends StatelessWidget {
  const BottomNavBarScreens({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = const [
      HomeScreen(),

      BookingScreen(),
      BookingSearchScreen(),
      NotificationsTabScreen(),
      ProfileScreen(),
    ];

    return Consumer<BottomNavProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          backgroundColor: ColorConstants.whiteColor,
          appBar: AppBar(
            backgroundColor: ColorConstants.whiteColor,
            surfaceTintColor: ColorConstants.whiteColor,
            title: Text(
              provider.getAppBarTitle(),
              style: const TextStyle(
                color: ColorConstants.primaryTextColor,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            actions: [
              if (provider.showProfileIcon)
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.blue.shade100,
                    child: const Icon(Icons.person, color: Colors.blue),
                  ),
                ),
            ],
          ),

          body: IndexedStack(index: provider.selectedIndex, children: screens),

          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: ColorConstants.whiteColor,
              boxShadow: [
                BoxShadow(
                  color: ColorConstants.disabledColor.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                ),
              ],
            ),
            child: BottomNavigationBar(
              currentIndex: provider.selectedIndex,
              onTap: provider.onItemTapped,
              type: BottomNavigationBarType.fixed,
              backgroundColor: ColorConstants.whiteColor,
              selectedItemColor: ColorConstants.primaryColor,
              unselectedItemColor: ColorConstants.disabledColor,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              selectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 12,
              ),
              items: <BottomNavigationBarItem>[
                const BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  label: 'Home',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.menu_book),
                  label: 'Booking',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: ColorConstants.primaryColor,
                      ),
                      child: const Icon(
                        Icons.search,
                        color: ColorConstants.whiteColor,
                        size: 28,
                      ),
                    ),
                  ),
                  label: '',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.message_outlined),
                  label: 'Message',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  label: 'Account',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
