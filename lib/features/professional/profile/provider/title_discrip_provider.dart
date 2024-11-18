import 'package:flutter/material.dart';

class TitleDescripProvider extends ChangeNotifier {
  final _titleContoller = TextEditingController();
 TextEditingController get titleContoller => _titleContoller;

  set titleContoller( value) {
    _titleContoller.text = value;
    notifyListeners();
  }
  
  final _descriptionContoller = TextEditingController();
 TextEditingController get descriptionContoller => _descriptionContoller;

  set descriptionContoller( value) {
    _descriptionContoller.text = value;
    notifyListeners();
  }
  
}
