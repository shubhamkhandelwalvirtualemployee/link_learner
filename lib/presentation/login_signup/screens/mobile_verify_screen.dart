import 'package:flutter/material.dart';
import 'package:link_learner/core/constants/app_images.dart';
import 'package:link_learner/core/constants/color_constants.dart';
import 'package:link_learner/core/constants/route_names.dart';
import 'package:link_learner/presentation/login_signup/provider/login_signup_provider.dart';
import 'package:link_learner/routes/app_routes.dart';
import 'package:link_learner/widgets/asset_images.dart';
import 'package:link_learner/widgets/common_elevated_button.dart';
import 'package:link_learner/widgets/phone_number_field.dart';

import 'package:provider/provider.dart';

class MobileVerifyScreen extends StatelessWidget {
  const MobileVerifyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginSignupProvider>(
      builder: (context, loginSignupProvider, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: ColorConstants.containerAndFillColor,
            surfaceTintColor: ColorConstants.containerAndFillColor,
            title: Text(
              "Continue With Phone",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorConstants.primaryTextColor,
              ),
            ),
          ),
          backgroundColor: ColorConstants.whiteColor,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                    top: 25,
                    left: 25,
                    right: 25,
                    bottom: 25,
                  ),
                  decoration: BoxDecoration(
                    color: ColorConstants.containerAndFillColor,
                  ),
                  child: assetImages(AppImages.mobile, height: 150, width: 150),
                ),

                // Form
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 30,
                  ),
                  decoration: const BoxDecoration(
                    color: ColorConstants.whiteColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                  child: Form(
                    key: loginSignupProvider.phoneKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Mobile

                        // Email
                        _buildLabel("Enter Yor Phone Number"),
                        const SizedBox(height: 20),
                        PhoneNumberField(
                          validator: (value) {
                            return loginSignupProvider.phoneNumberValidator(
                              value ?? "",
                            );
                          },
                          onChanged: (phone) {
                            print('Phone changed: $phone');
                          },
                          controller:
                              loginSignupProvider.mobileNumberVerifyController,
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: elevatedButton(
                            onTap: () {
                              AppRoutes.push(context, RouteNames.verifyPhone);
                            },
                            title: "Continue",
                            backgroundColor: ColorConstants.primaryColor,
                          ),
                        ),

                        // Password
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        color: ColorConstants.disabledColor,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
