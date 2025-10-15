import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:link_learner/core/constants/color_constants.dart';

Widget customTextField({
  TextEditingController? controller,
  String? hintText,
  bool? obsecure,
  String? Function(String?)? validator,
  Widget? suffixIcon, // Optional suffix icon
  TextInputType? keyboardType,
  Color? color,
  int maxLines = 1,
  Color? fillColor,
  void Function(String)? onChanged,
  bool? readOnly,
  VoidCallback? onTap,
}) {
  return TextFormField(
    onTap: onTap,
    onChanged: onChanged,
    maxLines: maxLines,
    readOnly: readOnly ?? false,
    style: TextStyle(color: color ?? ColorConstants.primaryTextColor),
    cursorColor: color ?? ColorConstants.primaryTextColor,
    validator: validator,
    controller: controller,
    obscureText: obsecure ?? false,
    keyboardType: keyboardType,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    inputFormatters:
        keyboardType == TextInputType.number
            ? [FilteringTextInputFormatter.digitsOnly]
            : [],
    decoration: InputDecoration(
      // filled: true,
      fillColor: fillColor ?? ColorConstants.containerAndFillColor,
      enabledBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: color ?? ColorConstants.disabledColor),
      ),
      errorStyle: const TextStyle(fontSize: 14),
      suffixIcon: suffixIcon,
      hintText: hintText ?? "",
      hintStyle: TextStyle(
        color: color ?? ColorConstants.containerAndFillColor,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: color ?? ColorConstants.disabledColor),
      ),
      border: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: color ?? ColorConstants.disabledColor),
      ),
    ),
  );
}
