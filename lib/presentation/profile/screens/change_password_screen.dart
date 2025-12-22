import 'package:flutter/material.dart';
import 'package:link_learner/core/constants/color_constants.dart';
import 'package:link_learner/presentation/profile/provider/change_password_provider.dart';
import 'package:link_learner/routes/app_routes.dart';
import 'package:link_learner/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<ChangePasswordProvider>(
      builder: (context, changePasswordProvider, child) {
        return Scaffold(
          backgroundColor: ColorConstants.whiteColor,
          appBar: AppBar(
            backgroundColor: ColorConstants.containerAndFillColor,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => AppRoutes.pop(context),
            ),
            title: Text(
              "Change Password",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: ColorConstants.primaryTextColor,
              ),
            ),
            elevation: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel("Current Password"),
                  customTextField(
                    controller: changePasswordProvider.oldPasswordController,
                    obsecure: !changePasswordProvider.isOldPasswordVisible,
                    suffixIcon: IconButton(
                      icon: Icon(
                        changePasswordProvider.isOldPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        changePasswordProvider.toggleOldPasswordVisibility();
                      },
                    ),
                    validator: changePasswordProvider.validatePassword,
                  ),
                  const SizedBox(height: 20),

                  _buildLabel("New Password"),
                  customTextField(
                    controller: changePasswordProvider.newPasswordController,
                    obsecure: !changePasswordProvider.isNewPasswordVisible,
                    suffixIcon: IconButton(
                      icon: Icon(
                        changePasswordProvider.isNewPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        changePasswordProvider.toggleNewPasswordVisibility();
                      },
                    ),
                    validator: changePasswordProvider.validatePassword,
                  ),
                  const SizedBox(height: 20),

                  _buildLabel("Confirm Password"),
                  customTextField(
                    controller:
                        changePasswordProvider.confirmPasswordController,
                    obsecure: !changePasswordProvider.isConfirmPasswordVisible,
                    suffixIcon: IconButton(
                      icon: Icon(
                        changePasswordProvider.isConfirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        changePasswordProvider
                            .toggleConfirmPasswordVisibility();
                      },
                    ),
                    validator: (value) {
                      if (value !=
                          changePasswordProvider.newPasswordController.text) {
                        return 'Passwords do not match';
                      }
                      return changePasswordProvider.validatePassword(value);
                    },
                  ),
                  const SizedBox(height: 40),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child:
                        changePasswordProvider.isLoading
                            ? const Center(
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              ),
                            )
                            : ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  changePasswordProvider.changePassword(
                                    context,
                                    _formKey,
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorConstants.primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                "Change Password",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                  ),
                ],
              ),
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
