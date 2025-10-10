import 'package:flutter/material.dart';

Widget networkImage(
  String? imageName, {
  double? height,
  double? width,
  BoxFit fit = BoxFit.contain,
}) {
  return Image.network(
    imageName ?? "",
    height: height,
    width: width,
    fit: fit,
    errorBuilder:
        (context, error, stackTrace) =>
            Center(child: Icon(Icons.image_not_supported_rounded)),
  );
}

NetworkImage networkImages(String imageName) {
  return NetworkImage(imageName);
}
