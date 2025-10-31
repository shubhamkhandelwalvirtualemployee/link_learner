import 'package:flutter/material.dart';
import 'package:link_learner/core/constants/color_constants.dart';
import 'package:link_learner/core/constants/route_names.dart';
import 'package:link_learner/presentation/profile/provider/profile_provider.dart';
import 'package:link_learner/routes/app_routes.dart';
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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Card(
                    color: ColorConstants.primaryColor,
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      leading: CircleAvatar(
                        backgroundColor: ColorConstants.containerAndFillColor,
                        child: Icon(Icons.person_3_rounded),
                      ),
                      title: Text(
                        "Alex Marker",
                        style: TextStyle(color: ColorConstants.whiteColor),
                      ),
                      subtitle: Text(
                        "@alexmarker",
                        style: TextStyle(color: ColorConstants.whiteColor),
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          AppRoutes.push(context, RouteNames.editProfileScreen);
                        },
                        icon: Icon(
                          Icons.edit_rounded,
                          color: ColorConstants.whiteColor,
                        ),
                      ),
                    ),
                  ),
                  // Stack(
                  //   clipBehavior: Clip.none,
                  //   alignment: Alignment.center,
                  //   children: [
                  //     // Profile Icon or Image
                  //     Container(
                  //       height: 150,
                  //       width: 150,
                  //       decoration: BoxDecoration(
                  //         shape: BoxShape.circle,
                  //         color: ColorConstants.containerAndFillColor,
                  //       ),
                  //       child:
                  //           profileProvider.coverImage != null
                  //               ? CircleAvatar(
                  //                 backgroundColor: ColorConstants.whiteColor,
                  //                 backgroundImage: FileImage(
                  //                   profileProvider.coverImage!,
                  //                 ),
                  //               )
                  //               : const Icon(
                  //                 Icons.person_rounded,
                  //                 size: 100,
                  //                 color: ColorConstants.primaryColor,
                  //               ),
                  //     ),
                  //     Positioned(
                  //       top: 10,
                  //       right: 15,
                  //       child: GestureDetector(
                  //         onTap: () {
                  //           profileProvider.pickImage(context);
                  //         },
                  //         // Pick image on tap
                  //         child: Container(
                  //           padding: const EdgeInsets.all(4),
                  //           decoration: const BoxDecoration(
                  //             shape: BoxShape.circle,
                  //             color: ColorConstants.primaryColor,
                  //           ),
                  //           child: const Icon(
                  //             Icons.camera_alt,
                  //             size: 16,
                  //             color: ColorConstants.whiteColor,
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  SizedBox(height: 20),
                  ListTile(
                    dense: true,
                    leading: CircleAvatar(
                      backgroundColor: ColorConstants.containerAndFillColor,
                      child: Icon(
                        Icons.favorite_border_rounded,
                        color: ColorConstants.primaryColor,
                      ),
                    ),
                    onTap: () {},

                    title: Text(
                      "Favourite",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: ColorConstants.disabledColor,
                      size: 18,
                    ),
                  ),
                  SizedBox(height: 10),
                  ListTile(
                    dense: true,
                    leading: CircleAvatar(
                      backgroundColor: ColorConstants.containerAndFillColor,
                      child: Icon(
                        Icons.attach_money_rounded,
                        color: ColorConstants.primaryColor,
                      ),
                    ),
                    title: Text(
                      "Payment History",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: ColorConstants.disabledColor,
                      size: 18,
                    ),
                  ),
                  SizedBox(height: 10),
                  ListTile(
                    dense: true,
                    leading: CircleAvatar(
                      backgroundColor: ColorConstants.containerAndFillColor,
                      child: Icon(
                        Icons.list_rounded,
                        color: ColorConstants.primaryColor,
                      ),
                    ),
                    title: Text(
                      "Booking List",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: ColorConstants.disabledColor,
                      size: 18,
                    ),
                  ),
                  SizedBox(height: 10),
                  ListTile(
                    dense: true,
                    leading: CircleAvatar(
                      backgroundColor: ColorConstants.containerAndFillColor,
                      child: Icon(
                        Icons.feedback_rounded,
                        color: ColorConstants.primaryColor,
                      ),
                    ),
                    title: Text(
                      "Feedback from providers",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: ColorConstants.disabledColor,
                      size: 18,
                    ),
                  ),
                  SizedBox(height: 10),
                  ListTile(
                    dense: true,
                    leading: CircleAvatar(
                      backgroundColor: ColorConstants.containerAndFillColor,
                      child: Icon(
                        Icons.bookmarks_rounded,
                        color: ColorConstants.primaryColor,
                      ),
                    ),
                    title: Text(
                      "Test booking",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: ColorConstants.disabledColor,
                      size: 18,
                    ),
                  ),
                  SizedBox(height: 10),
                  ListTile(
                    dense: true,
                    onTap: (){
                      AppRoutes.push(context, RouteNames.changePasswordScreen);
                    },
                    leading: CircleAvatar(
                      backgroundColor: ColorConstants.containerAndFillColor,
                      child: Icon(
                        Icons.password_sharp,
                        color: ColorConstants.primaryColor,
                      ),
                    ),
                    title: Text(
                      "Change Password",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: ColorConstants.disabledColor,
                      size: 18,
                    ),
                  ),
                  SizedBox(height: 10),
                  ListTile(
                    dense: true,
                    leading: CircleAvatar(
                      backgroundColor: ColorConstants.containerAndFillColor,
                      child: Icon(
                        Icons.privacy_tip_rounded,
                        color: ColorConstants.primaryColor,
                      ),
                    ),
                    title: Text(
                      "Setting & Privacy",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: ColorConstants.disabledColor,
                      size: 18,
                    ),
                  ),
                  SizedBox(height: 10),
                  ListTile(
                    dense: true,
                    leading: CircleAvatar(
                      backgroundColor: ColorConstants.containerAndFillColor,
                      child: Icon(
                        Icons.help_outline_rounded,
                        color: ColorConstants.primaryColor,
                      ),
                    ),
                    title: Text(
                      "Help & Support",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: ColorConstants.disabledColor,
                      size: 18,
                    ),
                  ),
                  SizedBox(height: 10),
                  ListTile(
                    dense: true,
                    leading: CircleAvatar(
                      backgroundColor: ColorConstants.containerAndFillColor,
                      child: Icon(
                        Icons.info_outline_rounded,
                        color: ColorConstants.primaryColor,
                      ),
                    ),
                    title: Text(
                      "About App",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: ColorConstants.disabledColor,
                      size: 18,
                    ),
                  ),
                  SizedBox(height: 10),
                  ListTile(
                    dense: true,
                    leading: CircleAvatar(
                      backgroundColor: ColorConstants.containerAndFillColor,
                      child: Icon(
                        Icons.logout_rounded,
                        color: ColorConstants.primaryColor,
                      ),
                    ),
                    title: Text(
                      "Log out",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: ColorConstants.disabledColor,
                      size: 18,
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
}
