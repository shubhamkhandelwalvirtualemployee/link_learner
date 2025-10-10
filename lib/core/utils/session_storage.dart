// import 'package:link_learner/core/utils/session_manager.dart';

// final SessionManager _sessionManager = SessionManager();

// Future<void> saveUserSession(AppleLoginResponseModel response) async {
//   if (response.user != null) {
//     await _sessionManager.setValue(
//       SessionConstants.userName,
//       response.user!.fullName ?? "",
//     );
//     await _sessionManager.setValue(
//       SessionConstants.userId,
//       response.user!.id ?? "",
//     );
//     await _sessionManager.setValue(
//       SessionConstants.userProfilePicture,
//       response.user!.profilePicture ?? "",
//     );
//     await _sessionManager.setValue(
//       SessionConstants.userType,
//       response.user?.userType?.trim().toLowerCase() ?? "",
//     );
//   }

//   if (response.token != null) {
//     await _sessionManager.setValue(
//       SessionConstants.accessToken,
//       response.token!,
//     );
//   }
// }
