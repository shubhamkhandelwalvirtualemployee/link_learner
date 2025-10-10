import 'package:flutter/material.dart';
import 'package:link_learner/core/constants/color_constants.dart';
import 'package:link_learner/core/constants/route_names.dart';
import 'package:link_learner/presentation/login_signup/provider/login_signup_provider.dart';
import 'package:link_learner/routes/app_routes.dart';
import 'package:link_learner/widgets/common_elevated_button.dart';
import 'package:link_learner/widgets/custom_text_field.dart';
import 'package:link_learner/widgets/phone_number_field.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginSignupProvider>(
      builder: (context, loginSignupProvider, child) {
        return Scaffold(
          backgroundColor: ColorConstants.whiteColor,
          body: SingleChildScrollView(
            child: Column(
              children: [
                // Header
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
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: ColorConstants.primaryTextColor,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Enter your details below & free sign up",
                        style: TextStyle(
                          color: ColorConstants.disabledColor,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                // Form
                Container(
                  width: double.infinity,
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
                    key: loginSignupProvider.signupFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name
                        _buildLabel("Your Name"),
                        customTextField(
                          controller: loginSignupProvider.signUpNameController,
                          validator:
                              (value) =>
                                  value == null || value.trim().isEmpty
                                      ? "Name is required"
                                      : null,
                        ),
                        const SizedBox(height: 10),

                        // Address
                        _buildLabel("Your Address"),
                        customTextField(
                          controller:
                              loginSignupProvider.signUpAddressController,
                          validator:
                              (value) =>
                                  value == null || value.trim().isEmpty
                                      ? "Address is required"
                                      : null,
                        ),
                        const SizedBox(height: 10),

                        // Mobile
                        _buildLabel("Mobile"),
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
                              loginSignupProvider.mobileNumberSignupController,
                        ),
                        const SizedBox(height: 10),

                        // Email
                        _buildLabel("Your Email"),
                        customTextField(
                          controller: loginSignupProvider.signUpEmailController,
                          validator:
                              (value) =>
                                  loginSignupProvider.validateEmail(value),
                        ),
                        const SizedBox(height: 10),

                        // DOB
                        _buildLabel("Date Of Birth"),
                        customTextField(
                          controller: loginSignupProvider.dateOfBirthController,
                          readOnly: true,
                          suffixIcon: const Icon(Icons.calendar_today),
                          onTap: () => loginSignupProvider.pickDate(context),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Date of birth is required';
                            }
                            if (!loginSignupProvider.isAbove16(
                              loginSignupProvider.selectedDate,
                            )) {
                              return 'Age must be at least 16 years';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),

                        // License
                        _buildLabel("License Number"),
                        customTextField(
                          controller:
                              loginSignupProvider.licenseNumberController,
                          validator:
                              (value) =>
                                  value == null || value.trim().isEmpty
                                      ? "License Number is required"
                                      : null,
                        ),
                        const SizedBox(height: 10),

                        // Password
                        _buildLabel("Password"),
                        customTextField(
                          controller:
                              loginSignupProvider.signUpPasswordController,
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
                        const SizedBox(height: 10),

                        // Checkbox
                        CheckboxListTile(
                          value: loginSignupProvider.isChecked,
                          activeColor: ColorConstants.primaryColor,
                          contentPadding: EdgeInsets.zero,
                          controlAffinity: ListTileControlAffinity.leading,
                          title: Text(
                            "By creating an account, you agree to our Terms & Conditions.",
                            style: TextStyle(
                              color: ColorConstants.iconColor,
                              fontSize: 13,
                            ),
                          ),
                          onChanged: (value) {
                            loginSignupProvider.toggleCheckbox();
                          },
                        ),

                        const SizedBox(height: 20),

                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: elevatedButton(
                            onTap: () {
                              // if (loginSignupProvider
                              //     .signupFormKey
                              //     .currentState!
                              //     .validate()) {
                              //   // Handle signup logic
                              // }

                              AppRoutes.push(
                                context,
                                RouteNames.mobileVerifyScreen,
                              );
                            },
                            title: "Create Account",
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
                                  RouteNames.loginScreen,
                                  (Route<dynamic> route) => false,
                                );
                              },
                              child: const Text(
                                "Log In",
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
