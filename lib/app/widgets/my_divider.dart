import 'package:ca_appoinment/app/theme/color.dart';
import 'package:flutter/material.dart';

class MyDivider extends StatelessWidget {
  const MyDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Divider(color: AppPalates.greyShade100, height: 20, thickness: 2);
  }
}