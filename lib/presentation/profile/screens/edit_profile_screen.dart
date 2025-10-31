import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:link_learner/core/constants/color_constants.dart';
import 'package:link_learner/presentation/profile/provider/profile_provider.dart';
import 'package:link_learner/widgets/common_elevated_button.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _gender;

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final provider = Provider.of<ProfileProvider>(context, listen: false);

      await provider.getProfile(); // fetch profile first

      final learner = provider.profileResponse?.data.user.learner;

      setState(() {
        _gender = null; // since gender isn’t in API yet
      });

      // Sync dropdown selections from fetched data into provider state
      if (learner?.preferences != null) {
        provider.setTransmissionType(
          learner!.preferences!.transmissionType ?? 'Manual',
        );
        provider.setPreferenceTime(
          learner.preferences!.preferredTime ?? 'Evenings',
        );
      } else {
        provider.setTransmissionType('Manual');
        provider.setPreferenceTime('Evenings');
      }
    });
  }


  Future<void> _pickDate(BuildContext context, TextEditingController controller) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(controller.text) ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      // Format date as "dd MMM yyyy"
      final formattedDate = DateFormat('dd MMM yyyy').format(pickedDate);
      controller.text = formattedDate;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, child) {
        final user = profileProvider.profileResponse?.data.user;

        return Scaffold(
          backgroundColor: ColorConstants.whiteColor,
          appBar: AppBar(
            backgroundColor: ColorConstants.whiteColor,
            elevation: 0.5,
            centerTitle: true,
            title: const Text(
              "Bio-data",
              style: TextStyle(
                color: ColorConstants.primaryGrey,
                fontWeight: FontWeight.w600,
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back,
                  color: ColorConstants.primaryGrey),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: SafeArea(
            child: profileProvider.isLoading &&
                profileProvider.profileResponse == null
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 18, vertical: 12),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 8),

                      // Profile Image
                      Center(
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 36,
                              backgroundColor:
                              ColorConstants.containerAndFillColor,
                              backgroundImage:
                              profileProvider.coverImage != null
                                  ? FileImage(
                                  profileProvider.coverImage!)
                                  : null,
                              child: profileProvider.coverImage == null
                                  ? const Icon(Icons.person,
                                  size: 40,
                                  color: ColorConstants.primaryColor)
                                  : null,
                            ),
                            Positioned(
                              right: -2,
                              bottom: -2,
                              child: GestureDetector(
                                onTap: () =>
                                    profileProvider.pickImage(context),
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(
                                    color: ColorConstants.primaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.camera_alt,
                                      size: 16, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),
                      Text(
                        "${user?.firstName ?? ''} ${user?.lastName ?? ''}"
                            .trim(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: ColorConstants.primaryGrey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user?.email ?? '',
                        style: const TextStyle(
                            fontSize: 12,
                            color: ColorConstants.disabledColor),
                      ),
                      const SizedBox(height: 18),

                      // Basic info
                      _underlinedTextField(
                        controller: profileProvider.firstNameController,
                        hint: "First name",
                        validator: (v) =>
                        (v == null || v.trim().isEmpty)
                            ? "Required"
                            : null,
                      ),
                      const SizedBox(height: 24),
                      _underlinedTextField(
                        controller: profileProvider.lastNameController,
                        hint: "Last name",
                        validator: (v) =>
                        (v == null || v.trim().isEmpty)
                            ? "Required"
                            : null,
                      ),
                      const SizedBox(height: 24),

                      _underlinedPhoneNumberField(
                        controller: profileProvider.phoneController,
                        hint: "Phone Number",
                        onChanged: (fullNumber) =>
                            profileProvider.setMobileNumber(fullNumber),
                      ),
                      const SizedBox(height: 24),

                      _underlinedDropdown(
                        value: _gender,
                        items: const ["Male", "Female", "Other"],
                        hint: "Choose gender",
                        onChanged: (val) =>
                            setState(() => _gender = val),
                      ),
                      const SizedBox(height: 24),
                      GestureDetector(
                        onTap: () => _pickDate(context, profileProvider.dateOfBirthController),
                        child: AbsorbPointer(
                          child: _underlinedTextField(
                            controller: profileProvider.dateOfBirthController,
                            hint: "DD MMM YYYY",
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      _underlinedTextField(
                          controller: profileProvider.addressController,
                          hint: "Address"),
                      const SizedBox(height: 24),
                      _underlinedTextField(
                          controller: profileProvider.cityController,
                          hint: "City"),
                      const SizedBox(height: 24),
                      _underlinedTextField(
                          controller: profileProvider.countyController,
                          hint: "County"),
                      const SizedBox(height: 24),
                      _underlinedTextField(
                          controller: profileProvider.postcodeController,
                          hint: "Postcode"),
                      const SizedBox(height: 24),
                      _underlinedTextField(
                          controller:
                          profileProvider.licenseNumberController,
                          hint: "License"),
                      const SizedBox(height: 24),
                      _underlinedTextField(
                          controller:
                          profileProvider.emergencyContactController,
                          hint: "Emergency Contact"),
                      const SizedBox(height: 24),
                      _underlinedTextField(
                          controller: profileProvider.goalsController,
                          hint: "Your Goals"),
                      const SizedBox(height: 24),
                      _underlinedTextField(
                          controller:
                          profileProvider.experienceController,
                          hint: "Experience"),

                      const SizedBox(height: 24),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          "Preferred Time",
                          style: TextStyle(
                            fontSize: 14,
                            color: ColorConstants.primaryGrey,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _preferenceRadio(
                            "Morning",
                            isSelected:
                            profileProvider.selectedPreferenceTime ==
                                "Morning",
                            onTap: () =>
                                profileProvider.setPreferenceTime(
                                    "Morning"),
                          ),
                          const SizedBox(width: 24),
                          _preferenceRadio(
                            "Evenings",
                            isSelected:
                            profileProvider.selectedPreferenceTime ==
                                "Evenings",
                            onTap: () =>
                                profileProvider.setPreferenceTime(
                                    "Evenings"),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          "Transmission Type",
                          style: TextStyle(
                            fontSize: 14,
                            color: ColorConstants.primaryGrey,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _preferenceRadio(
                            "Manual",
                            isSelected: profileProvider
                                .selectedTransmissionType ==
                                "Manual",
                            onTap: () => profileProvider
                                .setTransmissionType("Manual"),
                          ),
                          const SizedBox(width: 24),
                          _preferenceRadio(
                            "Automatic",
                            isSelected: profileProvider
                                .selectedTransmissionType ==
                                "Automatic",
                            onTap: () => profileProvider
                                .setTransmissionType("Automatic"),
                          ),
                        ],
                      ),

                      const SizedBox(height: 28),

                      // Update Button
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 50,
                              child: elevatedButton(
                                title: profileProvider.isLoading
                                    ? "Saving..."
                                    : "Update Profile",
                                backgroundColor:
                                ColorConstants.primaryColor,
                                onTap: profileProvider.isLoading
                                    ? null
                                    : () async {
                                  if (_formKey.currentState
                                      ?.validate() ??
                                      false) {
                                    final success =
                                    await profileProvider
                                        .updateProfile();
                                    if (!mounted) return;
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(success
                                          ? "Profile updated successfully"
                                          : "Failed to update profile"),
                                    ));
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _label(String text, {bool showPadding = true}) => Padding(
    padding: EdgeInsets.only(bottom: showPadding ? 8 : 0),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
            fontSize: 14, color: ColorConstants.disabledColor),
      ),
    ),
  );

  Widget _underlinedTextField({
    required TextEditingController controller,
    String? hint,
    String? Function(String?)? validator,
  }) =>
      Column(
        children: [
          TextFormField(
            controller: controller,
            validator: validator,
            decoration: InputDecoration(
              hintText: hint ?? '',
              hintStyle:
              const TextStyle(color: ColorConstants.disabledColor),
              border: InputBorder.none,
              contentPadding:
              const EdgeInsets.symmetric(vertical: 8),
            ),
          ),
          const Divider(height: 1, thickness: 1),
        ],
      );

  Widget _underlinedPhoneNumberField({
    required TextEditingController controller,
    String? initialCountryCode = 'IN',
    String? hint,
    String? Function(String?)? validator,
    ValueChanged<String>? onChanged,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IntlPhoneField(
            controller: controller,
            initialCountryCode: initialCountryCode,
            pickerDialogStyle: PickerDialogStyle(
              backgroundColor: ColorConstants.whiteColor,
            ),
            disableLengthCheck: true,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
            decoration: InputDecoration(
              hintText: hint ?? 'Phone number',
              hintStyle: const TextStyle(
                color: ColorConstants.disabledColor,
                fontSize: 14,
              ),
              border: InputBorder.none,
              contentPadding:
              const EdgeInsets.symmetric(vertical: 8),
            ),
            validator: (phone) =>
                validator?.call(phone?.completeNumber),
            onChanged: (phone) =>
                onChanged?.call(phone.completeNumber),
          ),
          const Divider(height: 1, thickness: 1),
        ],
      );

  Widget _underlinedDropdown({
    String? value,
    required List<String> items,
    String? hint,
    required void Function(String?) onChanged,
  }) =>
      Column(
        children: [
          DropdownButtonFormField<String>(
            value: value,
            items: items
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: onChanged,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 8),
            ),
          ),
          const Divider(height: 1, thickness: 1),
        ],
      );

  Widget _preferenceRadio(
      String title, {
        required bool isSelected,
        required VoidCallback onTap,
      }) =>
      GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? ColorConstants.primaryColor
                      : ColorConstants.disabledColor,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: ColorConstants.primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
              )
                  : null,
            ),
            const SizedBox(width: 8),
            Text(title,
                style: const TextStyle(
                    color: ColorConstants.primaryGrey)),
          ],
        ),
      );
}
