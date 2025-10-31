import 'dart:async';
import 'package:flutter/material.dart';
import 'package:link_learner/core/constants/color_constants.dart';
import 'package:link_learner/core/constants/route_names.dart';
import 'package:link_learner/routes/app_routes.dart';
import 'package:link_learner/widgets/asset_images.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Navigate to login screen after 2 seconds
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        AppRoutes.pushAndRemoveUntil(
          context,
          RouteNames.loginScreen,
              (Route<dynamic> route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.whiteColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App logo
            assetImages(
              "assets/images/onboarding_1.png", // update path if needed
              height: 150,
              width: 150,
            ),
            const SizedBox(height: 20),
            const Text(
              "Link Learner",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: ColorConstants.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
