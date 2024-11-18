// ignore_for_file: must_be_immutable

import 'package:ca_appoinment/app/theme/color.dart';
import 'package:flutter/material.dart';

class ExpenseTextField extends StatelessWidget {
  ExpenseTextField({
    super.key,
    required this.hintText,
    required this.suffixIcon,
    required this.controller,
    this.keyboardType = TextInputType.text,
  });
  String hintText;
  TextEditingController controller;
  TextInputType keyboardType;
  IconData suffixIcon;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: AppPalates.black),
      cursorColor: AppPalates.black,
      keyboardType: keyboardType,
      decoration: InputDecoration(
          suffixIcon: Icon(
            suffixIcon,
            color: AppPalates.primary,
          ),
          hintStyle: const TextStyle(color: AppPalates.black),
          enabledBorder: outlineBoder(),
          border: outlineBoder(),
          focusedBorder: outlineBoder(boderWidth: 2),
          hintText: hintText),
    );
  }
}

outlineBoder({double boderWidth = 1}) {
  return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
          color: AppPalates.primary.withOpacity(0.6), width: boderWidth));
}
