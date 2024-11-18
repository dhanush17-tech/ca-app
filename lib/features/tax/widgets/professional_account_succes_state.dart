// ignore_for_file: must_be_immutable

import 'package:ca_appoinment/app/routes/app_routes.dart';
import 'package:ca_appoinment/app/theme/color.dart';
import 'package:ca_appoinment/app/widgets/my_card_widget.dart';
import 'package:ca_appoinment/app/widgets/my_divider.dart';
import 'package:ca_appoinment/app/widgets/my_elevated_button.dart';
import 'package:ca_appoinment/features/professional/profile/models/pro_account_model.dart';
import 'package:ca_appoinment/features/user/widgets/user_profile_pic.dart';
import 'package:flutter/material.dart';

class ProfessionalAccountLoadedState extends StatelessWidget {
  ProfessionalAccountLoadedState({
    super.key,
    required this.accounts,
  });
  List<ProfessionalAccountModel> accounts;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: accounts.length,
      itemBuilder: (context, index) {
        var ca = accounts[index];
        return ProfessionalProfileContainer(ca: ca);
      },
    );
  }
}

class ProfessionalProfileContainer extends StatefulWidget {
  ProfessionalProfileContainer(
      {super.key, required this.ca, this.isDummy = false, this.title = ''});
  bool isDummy;
  String title;
  final ProfessionalAccountModel ca;

  @override
  State<ProfessionalProfileContainer> createState() =>
      _ProfessionalProfileContainerState();
}

class _ProfessionalProfileContainerState
    extends State<ProfessionalProfileContainer> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: MyCardWidget(
        elevation: 0,
        child: SizedBox(
          height: 200,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: UserProfilePic(
                              url: widget.ca.profileUrl,
                              pickedImage: null,
                            )),
                        const SizedBox(width: 15),
                        Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 20,
                                  width: 20,
                                ),
                                Text(
                                  widget.ca.userName!,
                                  maxLines: 1,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 19),
                                ),
                                Text(
                                  widget.isDummy
                                      ? widget.title
                                      : widget.ca.title!,
                                  maxLines: 2,
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                      overflow: TextOverflow.ellipsis),
                                ),
                                const Row(
                                  children: [
                                    // Row(
                                    //   children: [
                                    //     Icon(
                                    //       Icons.star_rounded,
                                    //       color: AppPalates.metalicGold,
                                    //     ),
                                    //     SizedBox(width: 3),
                                    //     FittedBox(child: Text('4.5'))
                                    //   ],
                                    // ),
                                    SizedBox(width: 10),
                                    // FittedBox(
                                    //   child: Text(
                                    //     '47 (Reviews)',
                                    //     style: TextStyle(
                                    //         color: AppPalates.textGrey,
                                    //         fontWeight:
                                    //             FontWeight.w500),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ],
                            )),
                      ],
                    ),
                  )),
              const MyDivider(),
              const SizedBox(height: 5),
              Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(3),
                    child: Row(
                      children: [
                        Expanded(
                          child: MyElevatedButton(
                              btName: 'Book',
                              onTap: () {
                                if (!widget.isDummy) {
                                  Navigator.pushNamed(context,
                                      AppRoutes.appointmentBookingScreen,
                                      arguments: widget.ca);
                                }
                              }),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: MyElevatedButton(
                              bgColor: AppPalates.black,
                              btName: 'View',
                              onTap: () {
                                if (!widget.isDummy) {
                                  Navigator.pushNamed(context,
                                      AppRoutes.taxFillingDetailsScreen,
                                      arguments: widget.ca);
                                }
                              }),
                        ),
                      ],
                    ),
                  )),
            ]),
          ),
        ),
      ),
    );
  }
}
