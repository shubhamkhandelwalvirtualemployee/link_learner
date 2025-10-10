import 'package:flutter/material.dart';
import 'package:link_learner/core/constants/color_constants.dart';

Widget elevatedButton({
  String? title,
  VoidCallback? onTap,
  Color? backgroundColor,
  Color textColor = ColorConstants.whiteColor,
}) {
  return ElevatedButton(
    onPressed: () {
      onTap!();
    },
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all<Color>(backgroundColor!),
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
    child: Text(
      title!,
      style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
    ),
  );
}
