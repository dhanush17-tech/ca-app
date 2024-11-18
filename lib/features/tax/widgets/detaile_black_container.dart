// ignore_for_file: must_be_immutable

import 'package:ca_appoinment/app/theme/color.dart';
import 'package:flutter/cupertino.dart';

class DetaileBlackContainer extends StatelessWidget {
  DetaileBlackContainer({
    super.key,
    required this.title,
    required this.subtitle,
  });

  String title;
  String subtitle;
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: AppPalates.primary, borderRadius: BorderRadius.circular(12)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
                color: AppPalates.white, fontWeight: FontWeight.bold),
          ),
          Text(
            subtitle,
            style: const TextStyle(
                color: AppPalates.white, fontWeight: FontWeight.bold),
          )
        ],
      ),
    ));
  }
}
