import 'package:flutter/material.dart';
import 'package:link_learner/core/constants/color_constants.dart';
import 'package:link_learner/core/constants/route_names.dart';
import 'package:link_learner/main.dart';
import 'package:link_learner/presentation/booking/screens/booking_details_screen.dart';
import 'package:link_learner/presentation/checkout/screens/payment_failed_screen.dart';
import 'package:link_learner/presentation/checkout/screens/payment_success_screen.dart';
import 'package:link_learner/presentation/bottom_nav_bar/screens/bottom_nav_bar_screens.dart';
import 'package:link_learner/presentation/checkout/screens/checkout_screen.dart';
import 'package:link_learner/presentation/instructor/model/intructor_list_model.dart';
import 'package:link_learner/presentation/instructor/screens/book_lesson_screen.dart';
import 'package:link_learner/presentation/instructor/screens/book_package_page.dart';
import 'package:link_learner/presentation/instructor/screens/instructor_detail_screen.dart';
import 'package:link_learner/presentation/instructor/screens/instructor_list_screen.dart';
import 'package:link_learner/presentation/login_signup/screens/reset_password_screen.dart';
import 'package:link_learner/presentation/login_signup/screens/login_screen.dart';
import 'package:link_learner/presentation/login_signup/screens/mobile_verify_screen.dart';
import 'package:link_learner/presentation/login_signup/screens/sign_up_screen.dart';
import 'package:link_learner/presentation/login_signup/screens/verify_phone.dart';
import 'package:link_learner/presentation/profile/screens/about_app_screen.dart';
import 'package:link_learner/presentation/profile/screens/feedback_screen.dart';
import 'package:link_learner/presentation/profile/screens/help_support_screen.dart';
import 'package:link_learner/presentation/profile/screens/payment_history_screen.dart';
import 'package:link_learner/presentation/splash/screens/splash_screen.dart';
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
      RouteNames.paymentHistoryScreen: (context) => PaymentHistoryScreen(),
      RouteNames.checkoutPage: (context) {
        final args = settings.arguments as Map<String, dynamic>;

        return CheckoutPage(
          instructor: args['instructor'],       // InstructorDetails object
          selectedDate: args['selectedDate'],   // DateTime
          selectedSlot: args['selectedSlot'],   // AvailabilitySlot
        );
      },
      RouteNames.paymentSuccessScreen: (context) => PaymentSuccessScreen(),
      RouteNames.paymentFailedScreen: (context) => PaymentFailedScreen(),
      RouteNames.bookingDetailsScreen: (context) {
        final item = ModalRoute.of(context)!.settings.arguments as String;
        return BookingDetailScreen(bookingId: item);
      },
      RouteNames.noNetworkScreen: (context) => NoNetworkScreen(),
      RouteNames.editProfileScreen: (context) => EditProfileScreen(),
      RouteNames.resetPasswordScreen: (context) => ResetPasswordScreen(),
      RouteNames.changePasswordScreen: (context) => ChangePasswordScreen(),
      RouteNames.instructorListScreen: (context) => InstructorListScreen(),
      RouteNames.bookLessonScreen: (context) => BookLessonScreen(),
      RouteNames.aboutAppScreen: (context) => AboutAppScreen(),
      RouteNames.helpSupportScreen: (context) => HelpSupportScreen(),
      RouteNames.feedbackScreen: (context) => FeedbackScreen(),
      RouteNames.instructorDetailsScreen: (context) {
        final args = settings.arguments as Map<String, dynamic>;

        final String instructorId = args['instructorId'];
        return InstructorDetailScreen(instructorId: instructorId);
      },
      RouteNames.bookInstructorPackageScreen: (context) {
        final args = settings.arguments as Map<String, dynamic>;

        final String instructorId = args['instructorId'];
        final InstructorUser instructorUser = args['user'];
        final double ratings = args['ratings'];
        final int hourlyRate = args['hourlyRate'];
        return BookInstructorPackageScreen(instructorId: instructorId,instructor: instructorUser,ratings: ratings,hourlyRate: hourlyRate,);
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
