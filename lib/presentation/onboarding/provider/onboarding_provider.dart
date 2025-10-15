import 'package:flutter/material.dart';
import 'package:link_learner/core/constants/app_images.dart';
import 'package:link_learner/core/constants/route_names.dart';

import 'package:link_learner/core/constants/session_constants.dart';
import 'package:link_learner/core/utils/session_manager.dart';
import 'package:link_learner/routes/app_routes.dart';

class OnboardingProvider extends ChangeNotifier {
  final PageController controller = PageController();
  int currentIndex = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "image": AppImages.onboarding1,
      "title": "Numerous free trial courses",
      "desc": "Free courses for you to find your way to learning",
    },
    {
      "image": AppImages.onboarding2,
      "title": "Quick and easy learning",
      "desc":
          "Easy and fast learning at any time to help you improve various skills",
    },
    {
      "image": AppImages.onboarding3,
      "title": "Create your own study plan",
      "desc": "Study according to the study plan, make study more motivated",
    },
  ];

  void onPageChanged(int index) {
    currentIndex = index;
    notifyListeners();
  }

  void skipToLastPage(BuildContext context) {
    SessionManager().setValue(
      SessionConstants.storeOnboarding,
      SessionConstants.storeOnboarding,
    );
    controller.jumpToPage(onboardingData.length - 1);
    AppRoutes.pushAndRemoveUntil(
      context,
      RouteNames.bottomNavBarScreens,
      (Route<dynamic> route) => false,
    );
  }
}
