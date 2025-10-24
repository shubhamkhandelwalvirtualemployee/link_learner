import 'package:flutter/material.dart';
import 'package:link_learner/core/constants/app_images.dart';
import 'package:link_learner/presentation/bottom_nav_bar/provider/bottom_nav_bar_provider.dart';
import 'package:link_learner/presentation/notifications/screens/notifications_tab_screen.dart';
import 'package:link_learner/presentation/booking/screens/booking_screen.dart';
import 'package:link_learner/widgets/asset_images.dart';
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
          appBar:
              provider.selectedIndex == 0
                  ? null // Hide AppBar only on Home screen
                  : AppBar(
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
                          child: GestureDetector(
                            onTap: () {
                              provider.onItemTapped(4);
                            },
                            child: CircleAvatar(
                              backgroundColor: Colors.blue.shade100,
                              child: const Icon(
                                Icons.person,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),

          body: IndexedStack(index: provider.selectedIndex, children: screens),

          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: ColorConstants.disabledColor.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
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
                items: [
                  BottomNavigationBarItem(
                    icon: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (provider.selectedIndex == 0)
                          Container(
                            width: 30,
                            height: 3,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: ColorConstants.primaryColor,
                              shape: BoxShape.rectangle,
                            ),
                          ),
                        SizedBox(height: 5),
                        assetImages(
                          AppImages.homeIcon,
                          height: 24,
                          iconColor:
                              provider.selectedIndex == 0
                                  ? ColorConstants.primaryColor
                                  : ColorConstants.disabledColor,
                        ),
                      ],
                    ),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (provider.selectedIndex == 1)
                          Container(
                            width: 30,
                            height: 3,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: ColorConstants.primaryColor,
                              shape: BoxShape.rectangle,
                            ),
                          ),
                        SizedBox(height: 5),
                        assetImages(
                          AppImages.bookingIcon,
                          height: 24,
                          iconColor:
                              provider.selectedIndex == 1
                                  ? ColorConstants.primaryColor
                                  : ColorConstants.disabledColor,
                        ),
                      ],
                    ),
                    label: 'Booking',
                  ),
                  BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ColorConstants.containerAndFillColor,
                        ),
                        child: const Icon(
                          Icons.search,
                          color: ColorConstants.primaryColor,
                          size: 28,
                        ),
                      ),
                    ),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (provider.selectedIndex == 3)
                          Container(
                            width: 30,

                            height: 3,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: ColorConstants.primaryColor,
                              shape: BoxShape.rectangle,
                            ),
                          ),
                        SizedBox(height: 5),
                        assetImages(
                          AppImages.messageIcon,
                          height: 24,
                          iconColor:
                              provider.selectedIndex == 3
                                  ? ColorConstants.primaryColor
                                  : ColorConstants.disabledColor,
                        ),
                      ],
                    ),
                    label: 'Message',
                  ),
                  BottomNavigationBarItem(
                    icon: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (provider.selectedIndex == 4)
                          Container(
                            width: 30,

                            height: 3,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: ColorConstants.primaryColor,
                              shape: BoxShape.rectangle,
                            ),
                          ),
                        SizedBox(height: 3),
                        Icon(
                          Icons.person,
                          size: 28,
                          color:
                              provider.selectedIndex == 4
                                  ? ColorConstants.primaryColor
                                  : ColorConstants.disabledColor,
                        ),
                      ],
                    ),
                    label: 'Account',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
