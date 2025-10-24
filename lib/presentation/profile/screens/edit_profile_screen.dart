import 'package:flutter/material.dart';
import 'package:link_learner/core/constants/color_constants.dart';
import 'package:link_learner/presentation/profile/provider/profile_provider.dart';
import 'package:link_learner/widgets/common_elevated_button.dart';
import 'package:link_learner/widgets/custom_text_field.dart';
import 'package:link_learner/widgets/phone_number_field.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, child) {
        return Scaffold(
          backgroundColor: ColorConstants.whiteColor,
          appBar: AppBar(
            title: const Text(
              "Edit Profile",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: ColorConstants.primaryTextColor,
              ),
            ),
            backgroundColor: ColorConstants.whiteColor,
            surfaceTintColor: ColorConstants.whiteColor,
          ),
          body: Container(
            padding: EdgeInsets.all(20),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      // Profile Icon or Image
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ColorConstants.containerAndFillColor,
                        ),
                        child:
                            profileProvider.coverImage != null
                                ? CircleAvatar(
                                  backgroundColor: ColorConstants.whiteColor,
                                  backgroundImage: FileImage(
                                    profileProvider.coverImage!,
                                  ),
                                )
                                : const Icon(
                                  Icons.person_rounded,
                                  size: 60,
                                  color: ColorConstants.primaryColor,
                                ),
                      ),
                      Positioned(
                        top: 2,
                        right: 12,
                        child: GestureDetector(
                          onTap: () {
                            profileProvider.pickImage(context);
                          },
                          // Pick image on tap
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: ColorConstants.primaryColor,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              size: 12,
                              color: ColorConstants.whiteColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Alex Marker",
                    style: const TextStyle(
                      fontSize: 16,
                      color: ColorConstants.primaryTextColor,

                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "@alexmarker",
                    style: const TextStyle(
                      fontSize: 12,
                      color: ColorConstants.disabledColor,

                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      _buildLabel("First Name"),
                      customTextField(
                        // controller: loginSignupProvider.signUpFirstNameController,
                        validator:
                            (value) =>
                                value == null || value.trim().isEmpty
                                    ? "Name is required"
                                    : null,
                      ),
                      const SizedBox(height: 10),
                      _buildLabel("Last Name"),
                      customTextField(
                        // controller: loginSignupProvider.signUpLastNameController,
                        validator:
                            (value) =>
                                value == null || value.trim().isEmpty
                                    ? "Name is required"
                                    : null,
                      ),
                      const SizedBox(height: 10),
                      _buildLabel("Mobile"),
                    ],
                  ),

                  PhoneNumberField(
                    initialCountryCode: "US", // e.g. "US" or "IN"
                    controller: profileProvider.mobileNumberSignupController,
                    onChanged: (fullNumber) {
                      print("Full number: $fullNumber");
                      profileProvider.setMobileNumber(fullNumber);
                    },
                  ),
                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: elevatedButton(
                            title: "Update Profile",
                            backgroundColor: ColorConstants.primaryColor,
                          ),
                        ),
                      ),
                    ],
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
