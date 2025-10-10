import 'package:flutter/material.dart';
import 'package:link_learner/core/constants/color_constants.dart';
import 'package:link_learner/presentation/profile/provider/profile_provider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, child) {
        return Scaffold(
          backgroundColor: ColorConstants.whiteColor,
          // appBar: AppBar(
          //   title: const Text(
          //     "Account",
          //     style: TextStyle(
          //       fontSize: 30,
          //       fontWeight: FontWeight.bold,
          //       color: ColorConstants.primaryTextColor,
          //     ),
          //   ),
          //   backgroundColor: ColorConstants.whiteColor,
          //   surfaceTintColor: ColorConstants.whiteColor,
          // ),
          body: Container(
            padding: EdgeInsets.all(20),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    // Profile Icon or Image
                    Container(
                      height: 150,
                      width: 150,
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
                                size: 100,
                                color: ColorConstants.primaryColor,
                              ),
                    ),
                    Positioned(
                      top: 10,
                      right: 15,
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
                            size: 16,
                            color: ColorConstants.whiteColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ListTile(
                  onTap: () {},

                  title: Text(
                    "Favourite",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: ColorConstants.disabledColor,
                  ),
                ),
                SizedBox(height: 10),
                ListTile(
                  title: Text(
                    "Edit Account",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: ColorConstants.disabledColor,
                  ),
                ),
                SizedBox(height: 10),
                ListTile(
                  title: Text(
                    "Settings and Privacy",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: ColorConstants.disabledColor,
                  ),
                ),
                SizedBox(height: 10),
                ListTile(
                  title: Text(
                    "Help",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: ColorConstants.disabledColor,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
