import 'dart:async';

import 'package:flutter/material.dart';
import 'package:link_learner/core/constants/color_constants.dart';
import 'package:link_learner/core/constants/route_names.dart';
import 'package:link_learner/core/constants/session_constants.dart';
import 'package:link_learner/core/utils/session_manager.dart';
import 'package:link_learner/routes/app_routes.dart';
import 'package:link_learner/widgets/asset_images.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  final SessionManager _sessionManager = SessionManager();
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1.1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _navigateUser();
  }

  void _navigateUser() async {
    String? accessToken = await _sessionManager.getValue(
      SessionConstants.accessToken,
    );

    Timer(const Duration(seconds: 2), () {
      if (!mounted) return; // ✅ Prevent navigation after dispose
      if (accessToken != null && accessToken.isNotEmpty) {
        AppRoutes.pushAndRemoveUntil(
          context,
          RouteNames.bottomNavBarScreens,
          (Route<dynamic> route) => false,
        );
      } else {
        AppRoutes.pushAndRemoveUntil(
          context,
          RouteNames.loginScreen,
          (Route<dynamic> route) => false,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // ✅ Properly dispose the AnimationController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.whiteColor,
      body: Center(
        child: ScaleTransition(
          scale: _scaleAnimation, // ✅ Apply animation to logo
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              assetImages(
                "assets/images/onboarding_1.png",
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
      ),
    );
  }
}
