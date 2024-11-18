// ignore_for_file: must_be_immutable

import 'package:ca_appoinment/app/theme/color.dart';
import 'package:flutter/cupertino.dart';

class MyLoadingContainer extends StatelessWidget {
  MyLoadingContainer({
    super.key,
    this.width = 140,
    this.height = 30,
  });
  double width;
  double height;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: AppPalates.greyShade100,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
