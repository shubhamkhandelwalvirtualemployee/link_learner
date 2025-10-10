import 'package:flutter/material.dart';
import 'package:link_learner/core/constants/color_constants.dart';
import 'package:link_learner/core/constants/route_names.dart';
import 'package:link_learner/routes/app_routes.dart';
import 'package:link_learner/widgets/common_elevated_button.dart';

void showSuccessDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // Prevent closing by tapping outside
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: ColorConstants.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: ColorConstants.whiteColor,
                  size: 40,
                ),
              ),
              const SizedBox(height: 24),

              // Title
              const Text(
                "Success",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: ColorConstants.primaryTextColor,
                ),
              ),

              const SizedBox(height: 8),

              // Subtitle
              const Text(
                "Congratulations, you have\ncompleted your registration!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: ColorConstants.disabledColor,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 24),

              // Done button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: elevatedButton(
                  title: "Done",
                  backgroundColor: ColorConstants.primaryColor,
                  onTap: () {
                    AppRoutes.pop(context);
                    AppRoutes.pushAndRemoveUntil(
                      context,
                      RouteNames.bottomNavBarScreens,
                      (Route<dynamic> route) => false,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
