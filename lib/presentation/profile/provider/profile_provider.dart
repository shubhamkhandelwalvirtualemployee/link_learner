import 'dart:io';
import 'package:flutter/material.dart';

import '../../../core/utils/pick_image.dart';

class ProfileProvider extends ChangeNotifier {
  final TextEditingController _signUpFirstNameController =
      TextEditingController();
  final TextEditingController _signUpLastNameController =
      TextEditingController();

  final TextEditingController _mobileNumberSignupController =
      TextEditingController();
  final TextEditingController _signUpEmailController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _licenseNumberController =
      TextEditingController();

  TextEditingController get signUpFirstNameController =>
      _signUpFirstNameController;

  TextEditingController get signUpLastNameController =>
      _signUpLastNameController;

  TextEditingController get signUpEmailController => _signUpEmailController;
  TextEditingController get dateOfBirthController => _dateOfBirthController;
  TextEditingController get licenseNumberController => _licenseNumberController;

  TextEditingController get mobileNumberSignupController =>
      _mobileNumberSignupController;

  File? _coverImage;

  File? get coverImage => _coverImage;

  Future<void> pickImage(BuildContext context) async {
    final image = await ImagePickerService.pickImage(context);
    if (image != null) {
      _coverImage = image;
      notifyListeners();
    }
  }

  void clearImage() {
    _coverImage = null;
    notifyListeners();
  }

  final String _countryCode = "US";
  String _fullMobileNumber = "";

  String get countryCode => _countryCode;
  String get fullMobileNumber => _fullMobileNumber;

  void setMobileNumber(String number) {
    _fullMobileNumber = number;
    notifyListeners();
  }
}
