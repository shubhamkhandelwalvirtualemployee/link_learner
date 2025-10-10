import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:link_learner/core/constants/color_constants.dart';
import 'package:otp_text_field_v2/otp_field_v2.dart';

class LoginSignupProvider extends ChangeNotifier {
  final GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> phoneKey = GlobalKey<FormState>();

  final TextEditingController _mobileNumberSignupController =
      TextEditingController();
  final TextEditingController _mobileNumberVerifyController =
      TextEditingController();
  final TextEditingController _signUpNameController = TextEditingController();
  final TextEditingController _signUpAddressController =
      TextEditingController();
  final TextEditingController _signUpEmailController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _licenseNumberController =
      TextEditingController();
  final TextEditingController _signUpPasswordController =
      TextEditingController();

  final TextEditingController _loginEmailController = TextEditingController();
  final TextEditingController _loginPasswordController =
      TextEditingController();

  final OtpFieldControllerV2 _verifyMobileOtpController = OtpFieldControllerV2();

  TextEditingController get mobileNumberSignupController =>
      _mobileNumberSignupController;
  TextEditingController get mobileNumberVerifyController =>
      _mobileNumberVerifyController;
  TextEditingController get signUpNameController => _signUpNameController;
  TextEditingController get signUpAddressController => _signUpAddressController;
  TextEditingController get signUpEmailController => _signUpEmailController;
  TextEditingController get dateOfBirthController => _dateOfBirthController;
  TextEditingController get licenseNumberController => _licenseNumberController;
  TextEditingController get signUpPasswordController =>
      _signUpPasswordController;
  TextEditingController get loginEmailController => _loginEmailController;
  TextEditingController get loginPasswordController => _loginPasswordController;
  OtpFieldControllerV2 get verifyMobileOtpController =>
      _verifyMobileOtpController;
  bool _isPasswordVisible = false;
  bool _isChecked = false;

  bool get isPasswordVisible => _isPasswordVisible;
  bool get isChecked => _isChecked;

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  void toggleCheckbox() {
    _isChecked = !_isChecked;
    notifyListeners();
  }

  set isPasswordVisible(bool value) {
    _isPasswordVisible = value;
    notifyListeners();
  }

  String? validateEmail(String? email) {
    email = email?.trim();
    if (email == null || email.isEmpty) {
      return 'Please enter your email.';
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      return 'Please enter a valid email.';
    }
    return null;
  }

  String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Please enter your password.';
    } else if (password.length < 6) {
      return 'Password must be at least 6 characters long.';
    }
    return null;
  }

  String? phoneNumberValidator(String value) {
    if (value.isEmpty || value.length < 10) {
      return 'Please enter a valid mobile number';
    }
    return null;
  }

  DateTime? _selectedDate;
  DateTime? get selectedDate => _selectedDate;

  /// ✅ Clears all text fields (signup, login, and phone-related)
  void clearTextFields() {
    _mobileNumberSignupController.clear();
    _mobileNumberVerifyController.clear();
    _signUpNameController.clear();
    _signUpAddressController.clear();
    _signUpEmailController.clear();
    _dateOfBirthController.clear();
    _licenseNumberController.clear();
    _signUpPasswordController.clear();
    _loginEmailController.clear();
    _loginPasswordController.clear();

    notifyListeners();
  }

  /// ✅ Dispose controllers properly to prevent memory leaks
  @override
  void dispose() {
    _mobileNumberSignupController.dispose();
    _mobileNumberVerifyController.dispose();
    _signUpNameController.dispose();
    _signUpAddressController.dispose();
    _signUpEmailController.dispose();
    _dateOfBirthController.dispose();
    _licenseNumberController.dispose();
    _signUpPasswordController.dispose();
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    super.dispose();
  }

  Future<void> pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 16)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: ColorConstants.primaryColor,
              onPrimary: ColorConstants.whiteColor,
              onSurface: ColorConstants.primaryTextColor,
            ),
            dialogTheme: DialogThemeData(
              backgroundColor: ColorConstants.whiteColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      selectedDate = picked;
    }
  }

  set selectedDate(DateTime? value) {
    _selectedDate = value;
    if (value != null) {
      _dateOfBirthController.text = DateFormat("dd/MM/yyyy").format(value);
    } else {
      _dateOfBirthController.clear();
    }
  }

  bool isAbove16(DateTime? date) {
    if (date == null) return false;
    final today = DateTime.now();
    final age = today.year - date.year;
    final hasHadBirthday =
        (today.month > date.month) ||
        (today.month == date.month && today.day >= date.day);
    return age > 16 || (age == 16 && hasHadBirthday);
  }
}
