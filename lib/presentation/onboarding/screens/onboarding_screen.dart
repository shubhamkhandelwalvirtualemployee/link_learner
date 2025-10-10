import 'package:flutter/material.dart';
import 'package:link_learner/core/constants/route_names.dart';
import 'package:link_learner/routes/app_routes.dart';
import 'package:provider/provider.dart';
import 'package:link_learner/core/constants/color_constants.dart';
import 'package:link_learner/widgets/asset_images.dart';
import 'package:link_learner/widgets/common_elevated_button.dart';
import 'package:link_learner/widgets/outlined_button.dart';
import 'package:link_learner/presentation/onboarding/provider/onboarding_provider.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OnboardingProvider(),
      child: Consumer<OnboardingProvider>(
        builder: (context, provider, _) {
          return Scaffold(
            backgroundColor: ColorConstants.whiteColor,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Stack(
                  children: [
                    PageView.builder(
                      controller: provider.controller,
                      itemCount: provider.onboardingData.length,
                      onPageChanged: provider.onPageChanged,
                      itemBuilder: (context, index) {
                        final item = provider.onboardingData[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 40,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              assetImages(
                                item["image"]!,
                                height: 200,
                                width: 200,
                              ),
                              const SizedBox(height: 20),
                              Text(
                                item["title"]!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: ColorConstants.primaryTextColor,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                item["desc"]!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: ColorConstants.disabledColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  provider.onboardingData.length,
                                  (index) => AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                    ),
                                    width:
                                        provider.currentIndex == index
                                            ? 30
                                            : 10,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color:
                                          provider.currentIndex == index
                                              ? ColorConstants.primaryColor
                                              : ColorConstants.primaryColor
                                                  .withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    // Skip button
                    if (provider.currentIndex !=
                        provider.onboardingData.length - 1)
                      Positioned(
                        top: 20,
                        right: 20,
                        child: GestureDetector(
                          onTap: () {
                            provider.skipToLastPage(context);
                          },
                          child: const Text(
                            "Skip",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                    // Buttons
                    if (provider.currentIndex ==
                        provider.onboardingData.length - 1)
                      Positioned(
                        bottom: 40,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 50,
                                child: elevatedButton(
                                  onTap: () {
                                    AppRoutes.pushAndRemoveUntil(
                                      context,
                                      RouteNames.signUpScreen,
                                      (Route<dynamic> route) => false,
                                    );
                                  },
                                  title: "Sign up",
                                  backgroundColor: ColorConstants.primaryColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: SizedBox(
                                height: 50,
                                child: outlinedButton(
                                  title: "Log in",
                                  onTap: () {
                                    AppRoutes.pushAndRemoveUntil(
                                      context,
                                      RouteNames.loginScreen,
                                      (Route<dynamic> route) => false,
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
