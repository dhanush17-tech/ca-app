import 'package:flutter/material.dart';

class ExpenseProvider extends ChangeNotifier {
  String _expenseType = 'income';
  String get expenseType => _expenseType;
  set  expenseType(String value) {
    _expenseType = value;
    notifyListeners();
  }

  final TextEditingController _noteContoller = TextEditingController();
  final TextEditingController _amountContoller = TextEditingController();
  TextEditingController get noteController => _noteContoller;
  TextEditingController get amountController => _amountContoller;

  String _categoryName = 'family';
  String get categoryName => _categoryName;
  set categoryName(String value) {
    _categoryName = value;
    notifyListeners();
  }

  int _categoryid = 2;
  int get categoryid => _categoryid;
  set categoryid(int value) {
    _categoryid = value;
    notifyListeners();
  }

  DateTime? _selectedDate = DateTime.now();
  DateTime? get selectedDate => _selectedDate;
  set selectedDate(value) {
    _selectedDate = value;
    notifyListeners();
  }
}
