// ignore_for_file: must_be_immutable

import 'package:ca_appoinment/app/theme/color.dart';
import 'package:flutter/material.dart';

class MyTextFormField extends StatelessWidget {
  MyTextFormField(
      {super.key,
      required this.hintText,
      required this.controller,
      required this.prefixIcon,
      this.suffixIcon,
      this.validator,
      this.keyboardType = TextInputType.text,
      this.isAbscured = false});
  String hintText;
  bool isAbscured;
  IconButton? suffixIcon;
  IconData prefixIcon;
  String? Function(String?)? validator;
  TextEditingController controller;
  TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      obscureText: isAbscured,
      style: const TextStyle(color: AppPalates.black),
      cursorColor: AppPalates.black,
      decoration: InputDecoration(
          prefixIcon: Icon(
            prefixIcon,
            color: AppPalates.primary.withOpacity(0.6),
          ),
          suffixIcon: suffixIcon,
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
