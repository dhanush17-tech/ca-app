// ignore_for_file: public_member_api_docs, sort_constructors_first, unused_field
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserProfileProvider extends ChangeNotifier {
  String? _downLoadUrl;

  String get downloadUrl => _downLoadUrl!;
  set downloadUrl(String url) {
    _downLoadUrl = url;
    notifyListeners();
  }

  File? _pickedImage;

  File? get pickedImage => _pickedImage;
  set pickedImage(File? url) {
    _pickedImage = url;
    notifyListeners();
  }

  getImage() async {
    var selectImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (selectImage != null) {
      _pickedImage = File(selectImage.path);
      notifyListeners();
    }
  }
}
