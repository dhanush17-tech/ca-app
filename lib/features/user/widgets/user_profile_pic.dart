// ignore_for_file: must_be_immutable

import 'dart:io';
import 'package:ca_appoinment/app/theme/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserProfilePic extends StatelessWidget {
  UserProfilePic({
    super.key,
    required this.url,
    this.pickedImage,
    this.picRadius = 70,
  });

  final String? url;
  File? pickedImage;
  double picRadius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: picRadius,
      backgroundColor: AppPalates.greyShade100,
      child: Builder(builder: (context) {
        if (url != null && pickedImage == null) {
          return CircleAvatar(
              radius: picRadius,
              backgroundImage: NetworkImage(url!),
              backgroundColor: AppPalates.greyShade100);
        } else if (url != null && pickedImage != null) {
          return CircleAvatar(
              radius: picRadius,
              backgroundImage: FileImage(File(pickedImage!.path)));
        } else if (url == null && pickedImage != null) {
          return CircleAvatar(
              radius: picRadius,
              backgroundImage: FileImage(File(pickedImage!.path)));
        } else {
          return Padding(
            padding: const EdgeInsets.all(4),
            child: Center(
              child: FittedBox(
                child: Icon(
                  CupertinoIcons.person,
                  color: AppPalates.black.withOpacity(0.5),
                  size: picRadius - 20,
                ),
              ),
            ),
          );
        }
      }),
    );
  }
}
