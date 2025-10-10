import 'package:flutter/material.dart';
import 'package:link_learner/core/constants/route_names.dart';
import 'package:link_learner/presentation/booking/provider/booking_provider.dart';
import 'package:link_learner/presentation/booking_and_search/provider/booking_search_provider.dart';
import 'package:link_learner/presentation/bottom_nav_bar/provider/bottom_nav_bar_provider.dart';
import 'package:link_learner/presentation/login_signup/provider/login_signup_provider.dart';
import 'package:link_learner/presentation/onboarding/provider/onboarding_provider.dart';
import 'package:link_learner/presentation/profile/provider/profile_provider.dart';
import 'package:link_learner/routes/route_manager.dart';
import 'package:provider/provider.dart';

String? fcmToken;
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<OnboardingProvider>(
          create: (context) => OnboardingProvider(),
        ),
        ChangeNotifierProvider<LoginSignupProvider>(
          create: (context) => LoginSignupProvider(),
        ),
        ChangeNotifierProvider<ProfileProvider>(
          create: (context) => ProfileProvider(),
        ),
        ChangeNotifierProvider<BookingSearchProvider>(
          create: (context) => BookingSearchProvider(),
        ),
        ChangeNotifierProvider<BottomNavProvider>(
          create: (context) => BottomNavProvider(),
        ),
        ChangeNotifierProvider<BookingProvider>(
          create: (context) => BookingProvider(),
        ),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,

        localizationsDelegates: [],
        title: 'LinkLearner',
        // theme: ThemeData(fontFamily: "Inter", useMaterial3: true),
        initialRoute: RouteNames.onboardingScreen,
        onGenerateRoute: RouteManager.onGenerateRoute,
      ),
    );
  }
}
