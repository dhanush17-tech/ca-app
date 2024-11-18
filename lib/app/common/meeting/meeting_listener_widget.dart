// ignore_for_file: must_be_immutable

import 'package:ca_appoinment/app/common/meeting/meeting_repository.dart';
import 'package:ca_appoinment/features/bookings/model/booking_time_model.dart';
import 'package:ca_appoinment/app/routes/app_routes.dart';
import 'package:ca_appoinment/app/theme/color.dart';
import 'package:ca_appoinment/app/widgets/my_card_widget.dart';
import 'package:ca_appoinment/app/widgets/my_elevated_button.dart';
import 'package:ca_appoinment/app/widgets/snack_bar.dart';
import 'package:ca_appoinment/features/meeting/models/meeting_arg.dart';
import 'package:ca_appoinment/features/user/blocs/user_bloc/user_bloc.dart';
import 'package:ca_appoinment/features/user/widgets/user_profile_pic.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class MeetingListenerWidget extends StatelessWidget {
  const MeetingListenerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<BookingTimeModel>>(
      stream: MeetingRepository.meetingListener(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          showSnackbar(context, snapshot.error.toString());
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppPalates.black,
            ),
          );
        }
        if (snapshot.hasData) {
          if (snapshot.data!.docs.isNotEmpty) {
            var model = snapshot.data!.docs.first.data();

            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BlocBuilder<UserBloc, UserState>(
                  builder: (context, state) {
                    if (state is UserSuccessState) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 8),
                        child: MyCardWidget(
                          elevation: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    FittedBox(
                                      child: Text(
                                        'Appoinment Id: ${model.serviceID!}',
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    const Text(
                                      'Started',
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: AppPalates.red,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 10),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.date_range_rounded,
                                      color: AppPalates.red,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      "${DateFormat.yMMMEd().format(model.bookingStart!)}, ${DateFormat('hh aa').format(model.bookingStart!)} T0 ${DateFormat('hh aa').format(model.bookingEnd!)}",
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color: AppPalates.red,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    UserProfilePic(
                                      picRadius: 35,
                                      url: model.proProfileUrl,
                                    ),
                                    const SizedBox(width: 20),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          model.proName!,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: AppPalates.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          model.serviceName == 'ca'
                                              ? 'Charted Accountant'
                                              : 'Financial Manager',
                                          style: const TextStyle(
                                              fontSize: 13,
                                              color: AppPalates.black),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  width: 300,
                                  child: MyElevatedButton(
                                      btName: 'Join Meeting',
                                      bgColor: AppPalates.red,
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, AppRoutes.meetingScreen,
                                            arguments: MeetingArgumnet(
                                              email: state.userModel.email!,
                                              name: state.userModel.name!,
                                              booking: model,
                                              profileUrl:
                                                  state.userModel.profilePic!,
                                              userId: state.userModel.uId!,
                                            ));
                                      }),
                                )
                              ],
                            ),
                          ),
                        ),
                      );

                      ///
                    }
                    return const SizedBox();
                  },
                )
              ],
            );
          } else {
            return const SizedBox();
          }
        }
        return const SizedBox();
      },
    );
  }
}
