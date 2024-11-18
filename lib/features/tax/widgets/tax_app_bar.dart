import 'package:flutter/material.dart';

import '../../../app/theme/color.dart';
import '../../../app/widgets/my_icon_pop_button.dart';

AppBar myTaxAppBar(String title) {
  return AppBar(
    backgroundColor: AppPalates.primary,
    surfaceTintColor: AppPalates.primary,
    leading: const Padding(
      padding: EdgeInsets.all(3),
      child: MyIconPopButton(),
    ),
    title: Text(
      title,
      style:
          const TextStyle(fontWeight: FontWeight.bold, color: AppPalates.white),
    ),
  );
}
