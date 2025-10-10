import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:link_learner/core/constants/color_constants.dart';

class PhoneNumberField extends StatelessWidget {
  final TextEditingController controller;
  final String? initialCountryCode;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;

  const PhoneNumberField({
    super.key,
    required this.controller,
    this.initialCountryCode = 'IN',
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
      builder: (fieldState) {
        return IntlPhoneField(
          pickerDialogStyle: PickerDialogStyle(
            backgroundColor: ColorConstants.whiteColor,
          ),
          disableLengthCheck: true,
          controller: controller,
          initialCountryCode: initialCountryCode,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: ColorConstants.disabledColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: ColorConstants.disabledColor),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: ColorConstants.disabledColor),
            ),
            hintStyle: TextStyle(color: ColorConstants.disabledColor),
            errorText: fieldState.errorText,
            errorStyle: const TextStyle(fontSize: 14),
          ),
          onChanged: (phone) {
            fieldState.didChange(phone.number);
            if (onChanged != null) onChanged!(phone.number);
          },
        );
      },
    );
  }
}
