import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:link_learner/core/constants/color_constants.dart';
import 'package:link_learner/routes/app_routes.dart';

class ImagePickerService {
  static Future<File?> pickImage(BuildContext context) async {
    final picker = ImagePicker();
    File? selectedImage;

    await showModalBottomSheet(
      isDismissible: true,
      enableDrag: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(0), // No rounding
        ),
      ),
      backgroundColor: ColorConstants.whiteColor,
      context: context,
      builder: (BuildContext ctx) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Take a photo'),
                onTap: () async {
                  final pickedFile = await picker.pickImage(
                    source: ImageSource.camera,
                  );
                  if (pickedFile != null) {
                    selectedImage = File(pickedFile.path);
                  }
                  AppRoutes.pop(ctx);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Choose from gallery'),
                onTap: () async {
                  final pickedFile = await picker.pickImage(
                    source: ImageSource.gallery,
                  );
                  if (pickedFile != null) {
                    selectedImage = File(pickedFile.path);
                  }
                  AppRoutes.pop(ctx);
                },
              ),
            ],
          ),
        );
      },
    );

    return selectedImage;
  }
}
