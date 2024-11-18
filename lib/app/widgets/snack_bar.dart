import 'package:ca_appoinment/app/theme/color.dart';
import 'package:flutter/material.dart';

showSnackbar(BuildContext context, String title) async {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: AppPalates.primary,
      content: Text(
        title,
        style: const TextStyle(
            fontWeight: FontWeight.bold, color: AppPalates.white),
      )));
}
