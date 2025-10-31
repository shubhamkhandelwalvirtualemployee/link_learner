import 'package:flutter/material.dart';
import 'package:link_learner/core/constants/color_constants.dart';
import 'package:link_learner/presentation/login_signup/provider/login_signup_provider.dart';
import 'package:link_learner/routes/app_routes.dart';
import 'package:link_learner/widgets/common_elevated_button.dart';
import 'package:link_learner/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<LoginSignupProvider>(
        builder: (context, loginSignupProvider, child) {
        return Scaffold(
          backgroundColor: ColorConstants.whiteColor,
          body: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(
                  top: 100,
                  left: 10,
                  right: 25,
                  bottom: 30,
                ),
                decoration: BoxDecoration(
                  color: ColorConstants.containerAndFillColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: () {
                            AppRoutes.pop(context);
                          },
                          icon: Icon(Icons.arrow_back),
                        ),
                        SizedBox(width: 20,),
                        Text(
                          "Reset Password",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: ColorConstants.primaryTextColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 30,),
                    _buildLabel("Your Email"),
                    SizedBox(height: 10,),
                    customTextField(
                      controller: loginSignupProvider.forgotEmailController,
                      validator:
                          (value) =>
                          loginSignupProvider.validateEmail(value),
                    ),
                    SizedBox(height: 40,),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: loginSignupProvider.isLoading?const Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                          ),
                        ),
                      ) :elevatedButton(
                        onTap: () {
                          loginSignupProvider.resetPassword(context);
                        },
                        title: "Send",
                        backgroundColor: ColorConstants.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),


            ],
          ),
        );
      }
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
