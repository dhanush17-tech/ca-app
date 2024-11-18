// ignore_for_file: must_be_immutable

import 'package:ca_appoinment/app/theme/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyProfileTile extends StatelessWidget {
  MyProfileTile({
    super.key,
    this.icon,
    required this.onTap,
    required this.title,
  });
  String title;
  VoidCallback onTap;
  IconData? icon;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shadowColor: AppPalates.black,
      color: AppPalates.grey,
      surfaceTintColor: AppPalates.white,
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        // splashColor: AppPalates.primary.withOpacity(0.6),
        leading: icon != null
            ? Icon(
                icon,
                color: AppPalates.primary,
              )
            : null,
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: const Icon(
          CupertinoIcons.chevron_right_circle_fill,
          color: AppPalates.primary,
          size: 30,
        ),
      ),
    );
  }
}
// CupertinoIcons.chevron_right_circle_fill