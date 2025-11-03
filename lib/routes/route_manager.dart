import 'package:flutter/material.dart';
import 'package:link_learner/core/constants/color_constants.dart';
import 'package:link_learner/core/constants/route_names.dart';
import 'package:link_learner/main.dart';
import 'package:link_learner/presentation/booking/screens/booking_details_screen.dart';
import 'package:link_learner/presentation/booking_and_search/screens/buy_booking_screen.dart';
import 'package:link_learner/presentation/booking_and_search/screens/checkout_screen.dart';
import 'package:link_learner/presentation/booking_and_search/screens/payment_failed_screen.dart';
import 'package:link_learner/presentation/booking_and_search/screens/payment_success_screen.dart';
import 'package:link_learner/presentation/bottom_nav_bar/screens/bottom_nav_bar_screens.dart';
import 'package:link_learner/presentation/instructor/screens/instructor_detail_screen.dart';
import 'package:link_learner/presentation/instructor/screens/instructor_list_screen.dart';
import 'package:link_learner/presentation/login_signup/screens/reset_password_screen.dart';
import 'package:link_learner/presentation/login_signup/screens/login_screen.dart';
import 'package:link_learner/presentation/login_signup/screens/mobile_verify_screen.dart';
import 'package:link_learner/presentation/login_signup/screens/sign_up_screen.dart';
import 'package:link_learner/presentation/login_signup/screens/verify_phone.dart';
import 'package:link_learner/presentation/onboarding/screens/onboarding_screen.dart';
import 'package:link_learner/presentation/profile/screens/change_password_screen.dart';
import 'package:link_learner/presentation/profile/screens/edit_profile_screen.dart';
import 'package:link_learner/presentation/profile/screens/profile_screen.dart';

class RouteManager {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final routes = <String, WidgetBuilder>{
      RouteNames.splashScreen: (context) => const SplashScreen(),
      RouteNames.signUpScreen: (context) => const SignUpScreen(),
      RouteNames.loginScreen: (context) => const LoginScreen(),
      RouteNames.mobileVerifyScreen: (context) => const MobileVerifyScreen(),
      RouteNames.verifyPhone: (context) => const VerifyPhone(),
      RouteNames.profileScreen: (context) => const ProfileScreen(),
      RouteNames.bottomNavBarScreens: (context) => BottomNavBarScreens(),
      RouteNames.buyBookingScreen: (context) => BuyBookingScreen(),
      RouteNames.checkoutScreen: (context) => CheckoutScreen(),
      RouteNames.paymentSuccessScreen: (context) => PaymentSuccessScreen(),
      RouteNames.paymentFailedScreen: (context) => PaymentFailedScreen(),
      RouteNames.bookingDetailsScreen: (context) => BookingDetailsScreen(),
      RouteNames.noNetworkScreen: (context) => NoNetworkScreen(),
      RouteNames.editProfileScreen: (context) => EditProfileScreen(),
      RouteNames.resetPasswordScreen: (context) => ResetPasswordScreen(),
      RouteNames.changePasswordScreen: (context) => ChangePasswordScreen(),
      RouteNames.instructorListScreen: (context) => InstructorListScreen(),
      RouteNames.instructorDetailsScreen: (context) {
        final args = settings.arguments as Map<String, dynamic>;

        final String instructorId = args['instructorId'];
        return InstructorDetailScreen(instructorId: instructorId);
      },
    };

    final builder = routes[settings.name];
    if (builder != null) {
      return PageRouteBuilder(
        settings: settings,
        pageBuilder:
            (context, animation, secondaryAnimation) => builder(context),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          final tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));
          final offsetAnimation = animation.drive(tween);

          return SlideTransition(position: offsetAnimation, child: child);
        },
      );
    }

    return MaterialPageRoute(
      builder:
          (context) => Scaffold(
            backgroundColor: ColorConstants.whiteColor,
            body: Center(child: Text("No Routes Defined.")),
          ),
    );
  }
}
