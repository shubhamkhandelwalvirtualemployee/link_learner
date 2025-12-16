import 'package:flutter/material.dart';
import 'package:link_learner/core/constants/color_constants.dart';
import 'package:link_learner/core/constants/route_names.dart';
import 'package:link_learner/core/utils/session_manager.dart';
import 'package:link_learner/presentation/login_signup/provider/login_signup_provider.dart';
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
  void initState() {
    super.initState();
    Future.microtask(() async {
      final provider = Provider.of<ProfileProvider>(context, listen: false);
      await provider.getProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, child) {
        return Scaffold(
          backgroundColor: ColorConstants.whiteColor,
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
                        profileProvider.profileResponse?.data?.user?.firstName ?? '',
                        style: TextStyle(color: ColorConstants.whiteColor),
                      ),
                      subtitle: Text(
                        profileProvider.profileResponse?.data?.user?.email ?? '',
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
                  SizedBox(height: 20),
                  ListTile(
                    dense: true,
                    leading: CircleAvatar(
                      backgroundColor: ColorConstants.containerAndFillColor,
                      child: Icon(
                        Icons.attach_money_rounded,
                        color: ColorConstants.primaryColor,
                      ),
                    ),
                    onTap: (){
                      AppRoutes.push(context, RouteNames.paymentHistoryScreen);
                    },
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
                    onTap: (){
                      AppRoutes.push(context, RouteNames.feedbackScreen);
                    },
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
                    onTap: (){
                      AppRoutes.push(context, RouteNames.helpSupportScreen);
                    },
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
                    onTap: (){
                      AppRoutes.push(context, RouteNames.aboutAppScreen);
                    },
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
                    onTap: (){
                      Provider.of<LoginSignupProvider>(context, listen: false).clearTextFields();
                      SessionManager().clearAll().then((value) {
                        AppRoutes.pushAndRemoveUntil(
                          context,
                          RouteNames.loginScreen,
                              (Route<dynamic> route) => false,
                        );
                      });
                    },
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
