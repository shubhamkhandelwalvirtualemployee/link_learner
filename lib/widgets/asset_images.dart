import 'package:flutter/material.dart';

Widget assetImages(
  String? imageName, {
  double? height,
  double? width,
  BoxFit fit = BoxFit.contain,
  Color? iconColor,
}) {
  return Image.asset(
    imageName!,
    height: height,
    width: width,
    fit: fit,
    color: iconColor,
  );
}
