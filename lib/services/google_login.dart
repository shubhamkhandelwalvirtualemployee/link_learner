import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseMessaging _messaging = FirebaseMessaging.instance;
final _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);

Future<void> signInWithGoogle(BuildContext context, String userType) async {
  try {
    final account = await _googleSignIn.signIn();
    if (account == null) return;

    final auth = await account.authentication;
    if (auth.idToken == null) {
      print("Google ID Token is null");
      return;
    }

    // final request = GoogleLoginRequestModel(
    //   displayName: account.displayName,
    //   email: account.email,
    //   id: account.id,
    //   photoUrl: account.photoUrl,
    //   serverAuthCode: account.serverAuthCode,
    //   userType: userType,
    // );

    // switch (userType.toLowerCase()) {
    //   case 'teacher':
    //     await context.read<CreateTeacherAccountProvider>().googleLoginAndSignup(
    //       context,
    //       request,
    //     );
    //     break;
    //   case 'student':
    //     await context.read<CreateStudentAccountProvider>().googleLoginAndSignup(
    //       context,
    //       request,
    //     );
    //     break;
    //   default:
    //     await context.read<LoginScreenProvider>().googleLoginAndSignup(
    //       context,
    //       request,
    //     );
    // }

    // 🔹 After successful login -> fetch Firebase token and update
    String? firebaseToken = await _messaging.getToken();
    // if (firebaseToken != null) {
    //   await ApiCalling().updateFirebaseToken(firebaseToken: firebaseToken);
    // }
  } catch (e) {
    print("Google Sign-In failed: $e");
  }
}
