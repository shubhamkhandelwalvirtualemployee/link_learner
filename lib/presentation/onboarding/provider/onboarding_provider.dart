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
      "title": "Numerous free trial",
      "desc": "Free courses for you to find your way to learning drivers",
    },
    {
      "image": AppImages.onboarding2,
      "title": "Quick and easy learner driver",
      "desc":
          "Easy and fast learning driving at any time to help you improve various driving skills",
    },
    {
      "image": AppImages.onboarding3,
      "title": "Create your own learner driver",
      "desc": "Driving according to the plan, make easy more motivated",
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
