// ignore_for_file: must_be_immutable

import 'dart:io';
import 'package:ca_appoinment/app/theme/color.dart';
import 'package:flutter/material.dart';

class FilePickContainer extends StatelessWidget {
  FilePickContainer(
      {super.key, required this.aadhaarFile, this.title, required this.ontap});

  File? aadhaarFile;
  String? title;
  VoidCallback ontap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title != null
            ? Text(
                title!,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: AppPalates.red),
              )
            : const SizedBox(),
        GestureDetector(
          onTap: ontap,
          child: Container(
            width: double.infinity,
            height: 140,
            decoration: BoxDecoration(
                image: aadhaarFile != null
                    ? DecorationImage(
                        image: FileImage(aadhaarFile!), fit: BoxFit.cover)
                    : null,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(width: 2),
                color: AppPalates.white),
            child: aadhaarFile == null
                ? const Center(
                    child: Text(
                    'Select Image',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppPalates.textGrey,
                      fontSize: 18,
                    ),
                  ))
                : null,
          ),
        ),
      ],
    );
  }
}
