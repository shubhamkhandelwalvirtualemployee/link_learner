import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:link_learner/core/constants/color_constants.dart';
import 'package:link_learner/presentation/login_signup/provider/login_signup_provider.dart';
import 'package:link_learner/presentation/login_signup/widgets/success_dialog.dart';
import 'package:link_learner/widgets/common_elevated_button.dart';
import 'package:otp_text_field_v2/otp_field_style_v2.dart';
import 'package:otp_text_field_v2/otp_field_v2.dart';
import 'package:provider/provider.dart';

class VerifyPhone extends StatelessWidget {
  const VerifyPhone({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginSignupProvider>(
      builder: (context, loginSignupProvider, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: ColorConstants.whiteColor,
            surfaceTintColor: ColorConstants.whiteColor,
            title: Text(
              "Verify Phone",
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildLabel("Code is sent to 27823837288732"),
                      const SizedBox(height: 20),

                      OTPTextFieldV2(
                        controller:
                            loginSignupProvider.verifyMobileOtpController,
                        inputFormatter: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        width: MediaQuery.of(context).size.width,
                        textFieldAlignment: MainAxisAlignment.spaceAround,
                        length: 4,
                        fieldWidth: 50,
                        outlineBorderRadius: 10,
                        otpFieldStyle: OtpFieldStyle(
                          disabledBorderColor: ColorConstants.disabledColor,
                          backgroundColor: ColorConstants.transparentColor,
                          borderColor: ColorConstants.disabledColor,
                          focusBorderColor: ColorConstants.primaryColor,
                          enabledBorderColor:
                              ColorConstants.containerAndFillColor,
                        ),
                        fieldStyle: FieldStyle.box,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        keyboardType: TextInputType.number,
                        onCompleted: (code) {
                          print("OTP Completed: $code");
                        },
                        onChanged: (value) {},
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: elevatedButton(
                          onTap: () {
                            showSuccessDialog(context);
                          },
                          title: "Verify and Create Account",
                          backgroundColor: ColorConstants.primaryColor,
                        ),
                      ),

                      // Password
                    ],
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
