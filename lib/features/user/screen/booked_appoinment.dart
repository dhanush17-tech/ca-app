import 'package:ca_appoinment/app/const/book_appointment_cont.dart';
import 'package:ca_appoinment/app/routes/app_routes.dart';
import 'package:ca_appoinment/app/theme/color.dart';
import 'package:ca_appoinment/app/widgets/my_card_widget.dart';
import 'package:ca_appoinment/app/widgets/my_elevated_button.dart';
import 'package:ca_appoinment/app/widgets/my_icon_pop_button.dart';
import 'package:ca_appoinment/features/meeting/models/meeting_arg.dart';
import 'package:ca_appoinment/features/professional/appoinments/blocs/my_appointments/my_appoinments_bloc.dart';
import 'package:ca_appoinment/features/user/blocs/booked_appointment_bloc/booked_appoinments_bloc.dart';
import 'package:ca_appoinment/features/user/widgets/user_profile_pic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class BookedAppoinmnetScreen extends StatefulWidget {
  const BookedAppoinmnetScreen({super.key});

  @override
  State<BookedAppoinmnetScreen> createState() => _BookedAppoinmnetScreenState();
}

class _BookedAppoinmnetScreenState extends State<BookedAppoinmnetScreen> {
  @override
  void initState() {
    super.initState();
    context.read<BookedAppoinmentsBloc>().add(BookedAppointmentFetchEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: const Padding(
          padding: EdgeInsets.all(3.0),
          child: MyIconPopButton(),
        ),
        title: const Text(
          'Booked Appointmnets',
          style: TextStyle(
              fontSize: 18,
              color: AppPalates.black,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocBuilder<BookedAppoinmentsBloc, BookedAppoinmentsState>(
        builder: (context, state) {
          if (state is BookedAppoinmentsLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is BookedAppoinmentsFailuerState) {
            return Center(child: Text(state.erroMsg));
          }
          if (state is BookedAppoinmentsSuccesState) {
            if (state.model.isEmpty) {
              return const Center(
                  child: Text(
                'No Bookings Found',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ));
            }
            return SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.model.length,
                    itemBuilder: (context, index) {
                      var model = state.model[index];
                      var appointmentTime =
                          "${DateFormat.yMMMEd().format(model.bookingStart!)}, ${DateFormat('hh aa').format(model.bookingStart!)} T0 ${DateFormat('hh aa').format(model.bookingEnd!)}";
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
                                    const SizedBox(width: 10),
                                    Builder(builder: (context) {
                                      Color textColor = AppPalates.black;
                                      switch (model.status) {
                                        case AppointmentConst.pending:
                                          textColor = AppPalates.orange;
                                          break;
                                        case AppointmentConst.completed:
                                          textColor = AppPalates.green;
                                          break;
                                        case AppointmentConst.cancelled:
                                          textColor = AppPalates.red;
                                          break;
                                        case AppointmentConst.rejected:
                                          textColor = AppPalates.red;
                                          break;
                                        default:
                                      }
                                      return Text(
                                        model.status!,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: textColor),
                                      );
                                    }),
                                    //
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.date_range_rounded,
                                      color: AppPalates.textGrey,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      appointmentTime,
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color: AppPalates.textGrey,
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
                                  width: double.infinity,
                                  child: model.userDocs == null &&
                                          model.status ==
                                              AppointmentConst.pending
                                      ? MyElevatedButton(
                                          btName: 'Upload Documents',
                                          onTap: () {
                                            Navigator.pushNamed(context,
                                                AppRoutes.docUploadScreen,
                                                arguments: model);
                                          },
                                          bgColor: AppPalates.red,
                                        )
                                      : const SizedBox(),
                                ),
                                DateTime.now().isAfter(model.bookingStart!) &&
                                        DateTime.now()
                                            .isBefore(model.bookingEnd!)
                                    ? SizedBox(
                                        width: double.infinity,
                                        child: MyElevatedButton(
                                          btName: 'Start Meeting',
                                          onTap: () {
                                            context.read<MyAppoinmentsBloc>().add(
                                                MyAppointmnetUpdateMeetingEvent(
                                                    map: model));
                                            Navigator.pushNamed(context,
                                                AppRoutes.meetingScreen,
                                                arguments: MeetingArgumnet(
                                                    booking: model,
                                                    userId: model.proId!,
                                                    email: model.proEmail!,
                                                    name: model.proName!,
                                                    profileUrl:
                                                        model.proProfileUrl!));
                                          },
                                          bgColor: AppPalates.primary,
                                        ))
                                    : const SizedBox(),
                                SizedBox(
                                  width: double.infinity,
                                  child: model.userDocs != null &&
                                              model.status ==
                                                  AppointmentConst.pending ||
                                          model.status ==
                                              AppointmentConst.completed
                                      ? MyElevatedButton(
                                          btName: 'View Documents',
                                          onTap: () {
                                            Navigator.pushNamed(context,
                                                AppRoutes.uploadedDocuments,
                                                arguments: model);
                                          },
                                          bgColor: AppPalates.primary,
                                        )
                                      : const SizedBox(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
