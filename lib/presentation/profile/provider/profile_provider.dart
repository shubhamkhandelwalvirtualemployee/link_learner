import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // ✅ for date formatting
import 'package:link_learner/core/constants/api_endpoint.dart';
import 'package:link_learner/presentation/profile/model/get_user_profile_model.dart';
import 'package:link_learner/services/api_service.dart';
import '../../../core/utils/pick_image.dart';

class ProfileProvider extends ChangeNotifier {
  final ApiService _api = ApiService();

  // --- Controllers ---
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _licenseNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _countyController = TextEditingController();
  final TextEditingController _postcodeController = TextEditingController();
  final TextEditingController _emergencyContactController = TextEditingController();
  final TextEditingController _goalsController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _preferencesController = TextEditingController();

  // --- Getters ---
  TextEditingController get firstNameController => _firstNameController;
  TextEditingController get lastNameController => _lastNameController;
  TextEditingController get emailController => _emailController;
  TextEditingController get phoneController => _phoneController;
  TextEditingController get dateOfBirthController => _dateOfBirthController;
  TextEditingController get licenseNumberController => _licenseNumberController;
  TextEditingController get addressController => _addressController;
  TextEditingController get cityController => _cityController;
  TextEditingController get countyController => _countyController;
  TextEditingController get postcodeController => _postcodeController;
  TextEditingController get emergencyContactController => _emergencyContactController;
  TextEditingController get goalsController => _goalsController;
  TextEditingController get experienceController => _experienceController;
  TextEditingController get preferencesController => _preferencesController;

  String? _selectedTransmissionType = "Manual";
  String? _selectedPreferenceTime = "Evenings";

  String? get selectedTransmissionType => _selectedTransmissionType;
  String? get selectedPreferenceTime => _selectedPreferenceTime;

  void setTransmissionType(String value) {
    _selectedTransmissionType = value;
    notifyListeners();
  }

  void setPreferenceTime(String value) {
    _selectedPreferenceTime = value;
    notifyListeners();
  }

  // --- Image handling ---
  File? _coverImage;
  File? get coverImage => _coverImage;

  void setMobileNumber(String number) {
    _phoneController.text = number;
    notifyListeners();
  }

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

  // --- Loading state ---
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // --- Profile model ---
  ProfileResponse? _profileResponse;
  ProfileResponse? get profileResponse => _profileResponse;

  // --- Fetch profile from API ---
  Future<void> getProfile() async {
    try {
      _setLoading(true);

      final response = await _api.get(ApiEndpoint.getProfile);
      _profileResponse = ProfileResponse.fromJson(response);

      final user = _profileResponse!.data.user;
      final learner = user.learner;

      // --- set UI fields ---
      _firstNameController.text = user.firstName;
      _lastNameController.text = user.lastName;
      _emailController.text = user.email;
      _phoneController.text = user.phone ?? '';

      // ✅ Format date for UI (dd-MMM-yyyy)
      if (learner?.dateOfBirth != null && learner!.dateOfBirth!.isNotEmpty) {
        try {
          final parsed = DateTime.parse(learner.dateOfBirth!);
          _dateOfBirthController.text = DateFormat('dd-MMM-yyyy').format(parsed);
        } catch (_) {
          _dateOfBirthController.text = learner.dateOfBirth!;
        }
      } else {
        _dateOfBirthController.text = '';
      }

      _licenseNumberController.text = learner?.licenseNumber ?? '';
      _addressController.text = learner?.address ?? '';
      _cityController.text = learner?.city ?? '';
      _countyController.text = learner?.county ?? '';
      _postcodeController.text = learner?.postcode ?? '';
      _emergencyContactController.text = learner?.emergencyContact ?? '';
      _goalsController.text = learner?.goals ?? '';
      _experienceController.text = learner?.experience ?? '';

      _selectedTransmissionType = learner?.preferences?.transmissionType ?? 'Manual';
      _selectedPreferenceTime = learner?.preferences?.preferredTime ?? 'Evenings';

      notifyListeners();
    } catch (e) {
      print("❌ Error fetching profile: $e");
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // --- Update profile ---
  Future<bool> updateProfile() async {
    try {
      _setLoading(true);

      String? formattedDob;
      if (_dateOfBirthController.text.isNotEmpty) {
        try {
          final parsed = DateFormat('dd-MMM-yyyy').parse(_dateOfBirthController.text);
          formattedDob = DateFormat('yyyy-MM-dd').format(parsed); // ✅ convert back for API
        } catch (_) {
          formattedDob = _dateOfBirthController.text;
        }
      }

      final body = {
        "firstName": _firstNameController.text.trim(),
        "lastName": _lastNameController.text.trim(),
        "phone": _phoneController.text.trim(),
        "avatar": _coverImage,
        "dateOfBirth": formattedDob,
        "address": _addressController.text.trim(),
        "city": _cityController.text.trim(),
        "county": _countyController.text.trim(),
        "postcode": _postcodeController.text.trim(),
        "licenseNumber": _licenseNumberController.text.trim(),
        "emergencyContact": _emergencyContactController.text.trim(),
        "goals": _goalsController.text.trim(),
        "experience": _experienceController.text.trim(),
        "preferences": {
          "transmissionType": _selectedTransmissionType,
          "preferredTime": _selectedPreferenceTime,
        },
      };

      // remove null/empty values before sending
      body.removeWhere((key, value) =>
      value == null ||
          (value is String && value.trim().isEmpty) ||
          (value is Map && value.isEmpty));

      final response = await _api.put(ApiEndpoint.updateProfile, body);
      print("✅ Update profile response: $response");

      return true;
    } catch (e) {
      print("❌ Error updating profile: $e");
      rethrow;
    } finally {
      _setLoading(false);
    }
  }
}
