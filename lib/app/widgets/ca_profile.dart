// ignore_for_file: must_be_immutable

import 'package:ca_appoinment/app/theme/color.dart';
import 'package:ca_appoinment/features/professional/profile/models/pro_account_model.dart';
import 'package:ca_appoinment/features/user/widgets/user_profile_pic.dart';
import 'package:flutter/material.dart';

class CaProfile extends StatelessWidget {
  const CaProfile({
    super.key,
    required this.model,
  });

  final ProfessionalAccountModel? model;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: AppPalates.primary,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Expanded(
                    flex: 1,
                    child: UserProfilePic(
                      url: model!.profileUrl,
                      pickedImage: null,
                    )),
                const SizedBox(width: 10),
                Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(height: 10),
                        Text(
                          model!.userName!,
                          maxLines: 1,
                          style: const TextStyle(
                              color: AppPalates.white,
                              fontWeight: FontWeight.w500,
                              overflow: TextOverflow.ellipsis,
                              fontSize: 19),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          model!.title!,
                          maxLines: 2,
                          style: TextStyle(
                              color: AppPalates.white.withOpacity(0.9),
                              fontWeight: FontWeight.w400,
                              overflow: TextOverflow.ellipsis,
                              fontSize: 13),
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
