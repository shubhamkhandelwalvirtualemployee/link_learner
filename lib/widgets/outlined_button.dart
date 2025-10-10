import 'package:flutter/material.dart';
import 'package:link_learner/core/constants/color_constants.dart';

Widget outlinedButton({
  String? title,
  VoidCallback? onTap,
  Color borderColor = ColorConstants.primaryColor,
  Color textColor = ColorConstants.primaryColor,
}) {
  return OutlinedButton(
    onPressed: () {
      if (onTap != null) onTap();
    },
    style: OutlinedButton.styleFrom(
      side: BorderSide(color: borderColor, width: 1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
    child: Text(
      title ?? '',
      style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
    ),
  );
}
