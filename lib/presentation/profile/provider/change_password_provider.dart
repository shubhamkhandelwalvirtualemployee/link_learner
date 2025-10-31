import 'package:flutter/material.dart';
import 'package:link_learner/core/constants/color_constants.dart';
import 'package:link_learner/services/api_calling.dart';
import 'package:link_learner/widgets/common_snack_bar.dart';

class ChangePasswordProvider extends ChangeNotifier {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  TextEditingController get oldPasswordController => _oldPasswordController;
  TextEditingController get newPasswordController => _newPasswordController;
  TextEditingController get confirmPasswordController => _confirmPasswordController;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isOldPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  bool get isOldPasswordVisible => _isOldPasswordVisible;
  bool get isNewPasswordVisible => _isNewPasswordVisible;
  bool get isConfirmPasswordVisible => _isConfirmPasswordVisible;

  void toggleOldPasswordVisibility() {
    _isOldPasswordVisible = !_isOldPasswordVisible;
    notifyListeners();
  }

  void toggleNewPasswordVisibility() {
    _isNewPasswordVisible = !_isNewPasswordVisible;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    notifyListeners();
  }

  String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Please enter your password.';
    } else if (password.length < 6) {
      return 'Password must be at least 6 characters long.';
    } else if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return 'Password must contain at least one uppercase letter.';
    } else if (!RegExp(r'[a-z]').hasMatch(password)) {
      return 'Password must contain at least one lowercase letter.';
    } else if (!RegExp(r'[0-9]').hasMatch(password)) {
      return 'Password must contain at least one number.';
    } else if (!RegExp(r'[!@#\$&*~]').hasMatch(password)) {
      return 'Password must contain at least one special character.';
    }
    return null;
  }

  Future<void> changePassword(BuildContext context, GlobalKey<FormState> formKey) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiCalling().changePassword(
        oldPassword: _oldPasswordController.text.trim(),
        newPassword: _newPasswordController.text.trim(),
      );

      if (response['success'] == true) {
        commonLongSnackBar(
          response['message'] ?? "Password changed successfully.",
          color: ColorConstants.primaryColor,
        );

        // ✅ Unfocus all text fields
        FocusScope.of(context).unfocus();

        // ✅ Clear text controllers
        _oldPasswordController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();

        // ✅ Reset validation errors on Form
        formKey.currentState?.reset();

        // ✅ Trigger UI rebuild so cleared values reflect instantly
        notifyListeners();
      } else {
        commonLongSnackBar(
          response['message'] ?? "Something went wrong",
          color: ColorConstants.primaryColor,
        );
      }
    } catch (e) {
      print("Error: $e");
      commonSnackBar('Password change error: $e',
          color: ColorConstants.primaryColor);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
