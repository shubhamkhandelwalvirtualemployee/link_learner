// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/widgets.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';
// import 'package:provider/provider.dart';
// import 'package:yoos_language/presentation/login/provider/login_screen_provider.dart';
// import 'package:yoos_language/presentation/signup/models/apple_login_request_model.dart';
// import 'package:yoos_language/presentation/signup/provider/create_student_screen_provider.dart';
// import 'package:yoos_language/presentation/signup/provider/create_teacher_account_provider.dart';
// import 'package:yoos_language/services/api_calling.dart';

// final FirebaseMessaging _messaging = FirebaseMessaging.instance;

// Future<void> signInWithApple(BuildContext context, String userType) async {
//   try {
//     final credential = await SignInWithApple.getAppleIDCredential(
//       scopes: [
//         AppleIDAuthorizationScopes.email,
//         AppleIDAuthorizationScopes.fullName,
//       ],
//       webAuthenticationOptions: WebAuthenticationOptions(
//         clientId: 'com.yoospeak.learnings',
//         redirectUri: Uri.parse('https://yoospeak.app/callback'),
//       ),
//     );

//     final appleUserId = credential.userIdentifier;
//     final idToken = credential.identityToken;

//     if (idToken == null) {
//       print("Apple ID Token is null");
//       return;
//     }

//     final request = AppleLoginRequestModel(
//       fullName: credential.givenName ?? "",
//       email: credential.email ?? "",
//       id: appleUserId,
//       photoUrl: "",
//       firebaseToken: idToken,
//       userType: userType,
//     );

//     switch (userType.toLowerCase()) {
//       case 'teacher':
//         await context.read<CreateTeacherAccountProvider>().appleLoginAndSignUp(
//           context,
//           request,
//         );
//         break;
//       case 'student':
//         await context.read<CreateStudentAccountProvider>().appleLoginAndSignUp(
//           context,
//           request,
//         );
//         break;
//       default:
//         await context.read<LoginScreenProvider>().appleLoginAndSignUp(
//           context,
//           request,
//         );
//     }

//     String? firebaseToken = await _messaging.getToken();
//     if (firebaseToken != null) {
//       await ApiCalling().updateFirebaseToken(firebaseToken: firebaseToken);
//     }
//   } catch (e) {
//     print("Apple Sign-In failed: $e");
//   }
// }
