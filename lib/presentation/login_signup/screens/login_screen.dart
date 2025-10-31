import 'package:flutter/material.dart';
import 'package:link_learner/core/constants/app_images.dart';
import 'package:link_learner/core/constants/color_constants.dart';
import 'package:link_learner/core/constants/route_names.dart';
import 'package:link_learner/presentation/login_signup/provider/login_signup_provider.dart';
import 'package:link_learner/routes/app_routes.dart';
import 'package:link_learner/widgets/asset_images.dart';
import 'package:link_learner/widgets/common_elevated_button.dart';
import 'package:link_learner/widgets/custom_text_field.dart';

import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginSignupProvider>(
      builder: (context, loginSignupProvider, child) {
        return Scaffold(
          backgroundColor: ColorConstants.whiteColor,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                    top: 100,
                    left: 25,
                    right: 25,
                    bottom: 30,
                  ),
                  decoration: BoxDecoration(
                    color: ColorConstants.containerAndFillColor,
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Log In",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: ColorConstants.primaryTextColor,
                        ),
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
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
                    key: loginSignupProvider.loginFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Mobile

                        // Email
                        _buildLabel("Your Email"),
                        customTextField(
                          controller: loginSignupProvider.loginEmailController,
                          validator:
                              (value) =>
                                  loginSignupProvider.validateEmail(value),
                        ),
                        const SizedBox(height: 20),

                        // Password
                        _buildLabel("Password"),
                        customTextField(
                          controller:
                              loginSignupProvider.loginPasswordController,
                          suffixIcon: IconButton(
                            icon: Icon(
                              loginSignupProvider.isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              loginSignupProvider.togglePasswordVisibility();
                            },
                          ),
                          obsecure: !loginSignupProvider.isPasswordVisible,
                          validator:
                              (value) =>
                                  loginSignupProvider.validatePassword(value),
                        ),
                        const SizedBox(height: 20),

                        // Checkbox
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                AppRoutes.push(
                                  context,
                                  RouteNames.resetPasswordScreen,
                                );
                              },
                              child: Text(
                                "Forgot password?",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: ColorConstants.disabledColor,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: elevatedButton(
                            onTap: () {
                              if (loginSignupProvider.loginFormKey.currentState!
                                  .validate()) {
                                loginSignupProvider.login(context);
                              }
                            },
                            title: "Log In",
                            backgroundColor: ColorConstants.primaryColor,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Login Text
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Already have an account? ",
                              style: TextStyle(
                                color: ColorConstants.disabledColor,
                                fontSize: 14,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                AppRoutes.pushAndRemoveUntil(
                                  context,
                                  RouteNames.signUpScreen,
                                  (Route<dynamic> route) => false,
                                );
                              },
                              child: const Text(
                                "Sign up",
                                style: TextStyle(
                                  decorationColor: ColorConstants.primaryColor,
                                  color: ColorConstants.primaryColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),
                       /* Row(
                          children: [
                            Expanded(child: Divider(endIndent: 20)),
                            Text(
                              "Or Login with",
                              style: TextStyle(
                                color: ColorConstants.disabledColor,
                              ),
                            ),
                            Expanded(child: Divider(indent: 20)),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {},
                              child: assetImages(
                                AppImages.googleIcon,
                                height: 50,
                                width: 50,
                              ),
                            ),
                            SizedBox(width: 30),
                            InkWell(
                              onTap: () {},
                              child: assetImages(
                                AppImages.facebookIcon,
                                height: 40,
                                width: 40,
                              ),
                            ),
                          ],
                        ),*/
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
