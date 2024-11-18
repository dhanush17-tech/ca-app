import 'package:ca_appoinment/app/theme/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyIconPopButton extends StatelessWidget {
  final double size;
  const MyIconPopButton({super.key, this.size = 25});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: IconButton(
        style: IconButton.styleFrom(backgroundColor: AppPalates.grey),
        icon: Icon(
          CupertinoIcons.back,
          size: size,
          color: AppPalates.primary,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}

class MyIconButton extends StatelessWidget {
  MyIconButton(
      {super.key, this.size = 25, required this.icon, required this.onTap});
  double size;
  VoidCallback onTap;
  IconData icon;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: IconButton(
        style: IconButton.styleFrom(backgroundColor: AppPalates.grey),
        icon: Icon(
          icon,
          size: size,
          color: AppPalates.primary,
        ),
        onPressed: onTap,
      ),
    );
  }
}
