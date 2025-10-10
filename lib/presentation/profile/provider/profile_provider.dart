import 'dart:io';
import 'package:flutter/material.dart';

import '../../../core/utils/pick_image.dart';

class ProfileProvider extends ChangeNotifier {
  File? _coverImage;

  File? get coverImage => _coverImage;

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
}
