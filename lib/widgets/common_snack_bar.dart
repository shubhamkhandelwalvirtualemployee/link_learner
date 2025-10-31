import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:link_learner/core/constants/color_constants.dart';

void commonSnackBar(
  String? text, {
  ToastGravity gravity = ToastGravity.BOTTOM,
  Color? color,
}) {
  Fluttertoast.showToast(
    msg: text ?? "",
    toastLength: Toast.LENGTH_SHORT,
    gravity: gravity,
    backgroundColor: color,
    textColor: ColorConstants.whiteColor,
    fontSize: 14.0,
  );
}

void commonLongSnackBar(
    String? text, {
      ToastGravity gravity = ToastGravity.BOTTOM,
      Color? color,
    }) {
  Fluttertoast.showToast(
    msg: text ?? "",
    toastLength: Toast.LENGTH_LONG,
    gravity: gravity,
    backgroundColor: color,
    textColor: ColorConstants.whiteColor,
    fontSize: 14.0,
  );
}
