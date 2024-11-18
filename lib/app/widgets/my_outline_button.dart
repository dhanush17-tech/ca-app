// ignore_for_file: must_be_immutable

import 'package:ca_appoinment/app/theme/color.dart';
import 'package:flutter/material.dart';

class MyOutlineButton extends StatelessWidget {
  MyOutlineButton({super.key, required this.btName, required this.onTap});
  String btName;
  VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
      child: FittedBox(
        child: Text(btName,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: AppPalates.primary)),
      ),
    );
  }
}
