// ignore_for_file: must_be_immutable

import 'package:ca_appoinment/app/theme/color.dart';
import 'package:flutter/material.dart';

class MyCardWidget extends StatelessWidget {
  MyCardWidget({super.key, required this.child, this.elevation = 0});
  Widget child;
  double elevation;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppPalates.white,
      elevation: elevation,
      surfaceTintColor: AppPalates.greyShade100,
      shadowColor: AppPalates.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(width: 3, color: Colors.grey.withOpacity(0.3)),
      ),
      child: child,
    );
  }
}
