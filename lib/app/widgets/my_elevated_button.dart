// ignore_for_file: must_be_immutable

import 'package:ca_appoinment/app/theme/color.dart';
import 'package:flutter/material.dart';

class MyElevatedButton extends StatelessWidget {
  MyElevatedButton(
      {super.key,
      required this.btName,
      required this.onTap,
      this.widget,
      this.textColor = AppPalates.white,
      this.fontSize = 18,
      this.bgColor = AppPalates.primary});
  String btName;
  VoidCallback onTap;
  Widget? widget;
  Color bgColor;
  Color textColor;
  double fontSize;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
            surfaceTintColor: AppPalates.textGrey,
            // padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
            backgroundColor: bgColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            )),
        child: FittedBox(
          child: widget ??
              Text(
                btName,
                style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    color: textColor),
              ),
        ));
  }
}
