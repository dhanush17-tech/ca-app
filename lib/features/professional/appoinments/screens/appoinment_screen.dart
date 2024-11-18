import 'package:ca_appoinment/app/core/push_notification_service.dart';
import 'package:ca_appoinment/features/bookings/model/booking_time_model.dart';
import 'package:ca_appoinment/app/const/book_appointment_cont.dart';
import 'package:ca_appoinment/app/routes/app_routes.dart';
import 'package:ca_appoinment/app/theme/color.dart';
import 'package:ca_appoinment/app/widgets/my_card_widget.dart';
import 'package:ca_appoinment/app/widgets/my_elevated_button.dart';
import 'package:ca_appoinment/features/meeting/models/meeting_arg.dart';
import 'package:ca_appoinment/features/professional/appoinments/blocs/my_appointments/my_appoinments_bloc.dart';
import 'package:ca_appoinment/features/user/widgets/user_profile_pic.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AppoinmentScreen extends StatefulWidget {
  const AppoinmentScreen({super.key});

  @override
  State<AppoinmentScreen> createState() => _AppoinmentScreenState();
}

class _AppoinmentScreenState extends State<AppoinmentScreen> {
  var appointmentViewContoller = TextEditingController();
  @override
  void initState() {
    super.initState();
    context.read<MyAppoinmentsBloc>().add(MyAppointmnetFetchEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          appointmentViewContoller.text == 'All'
              ? 'All Appointments'
              : 'Pending Appointments',
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        actions: [
          IconButton(
              onPressed: () {
                context
                    .read<MyAppoinmentsBloc>()
                    .add(MyAppointmnetFetchEvent());
              },
              icon: const Icon(CupertinoIcons.refresh_bold)),
        ],
        bottom: PreferredSize(
          preferredSize: const Size(double.infinity, 70),
          child: Align(
            alignment: Alignment.centerRight,
            child: MyCardWidget(
              elevation: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 7),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(12)),
                child: DropdownMenu(
                    inputDecorationTheme: InputDecorationTheme(
                        contentPadding: const EdgeInsets.all(5),
                        floatingLabelStyle:
                            TextField.materialMisspelledTextStyle,
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(12))),
                    menuStyle: const MenuStyle(
                        backgroundColor:
                            WidgetStatePropertyAll(AppPalates.white),
                        surfaceTintColor:
                            WidgetStatePropertyAll(AppPalates.white),
                        padding: WidgetStatePropertyAll(
                          EdgeInsets.all(10),
                        )),
                    controller: appointmentViewContoller,
                    initialSelection: 'All',
                    onSelected: (value) {
                      setState(() {
                        appointmentViewContoller.text = value!;
                      });
                    },
                    dropdownMenuEntries: [
                      'All',
                      AppointmentConst.pending,
                    ]
                        .map(
                          (e) => DropdownMenuEntry(
                            value: e,
                            label: e,
                          ),
                        )
                        .toList()),
              ),
            ),
          ),
        ),
      ),
      body: Center(
        child: BlocBuilder<MyAppoinmentsBloc, MyAppoinmentsState>(
          builder: (context, state) {
            if (state is MyAppoinmentsLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is MyAppoinmentsFailuerState) {
              return Center(child: Text(state.errorMsg));
            }
            if (state is MyAppoinmentsSuccesState) {
              if (appointmentViewContoller.text == 'All') {
                if (state.allAppoinmnets.isEmpty) {
                  return const Center(
                    child: Text(
                      'No Appointments Found',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppPalates.black,
                          fontSize: 20),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: state.allAppoinmnets.length,
                  itemBuilder: (context, index) {
                    var model = state.allAppoinmnets[index];

                    return AppointmentContainer(model: model);
                  },
                );
              } else {
                if (state.pending.isEmpty) {
                  return const Center(
                    child: Text(
                      'No Pending Appointments',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppPalates.black,
                          fontSize: 20),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: state.pending.length,
                  itemBuilder: (context, index) {
                    var model = state.pending[index];

                    return AppointmentContainer(model: model);
                  },
                );
              }
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}

class AppointmentContainer extends StatelessWidget {
  const AppointmentContainer({
    super.key,
    required this.model,
  });

  final BookingTimeModel model;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.uploadedDocuments,
            arguments: model);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
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
                            fontSize: 12, fontWeight: FontWeight.bold),
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
                            fontWeight: FontWeight.bold, color: textColor),
                      );
                    }),
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
                      "${DateFormat.yMMMEd().format(model.bookingStart!)}, ${DateFormat('hh aa').format(model.bookingStart!)} T0 ${DateFormat('hh aa').format(model.bookingEnd!)}",
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
                      url: model.userProfileUrl,
                    ),
                    const SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          model.userName!,
                          style: const TextStyle(
                              fontSize: 14,
                              color: AppPalates.black,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          model.userEmail!,
                          style: const TextStyle(
                              fontSize: 13, color: AppPalates.black),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                DateTime.now().isAfter(model.bookingStart!) &&
                        DateTime.now().isBefore(model.bookingEnd!)
                    ? SizedBox(
                        width: double.infinity,
                        child: MyElevatedButton(
                          btName: 'Start Meeting',
                          onTap: () async {
                            PushNotificationService.sendNotificationToSelectedUser(
                                model.userNfToken!,
                                RemoteMessage(
                                    notification: RemoteNotification(
                                        title: model.proName,
                                        body:
                                            'Meeting Started\n${DateFormat.yMMMEd().format(model.bookingStart!)}, ${DateFormat('hh aa').format(model.bookingStart!)} T0 ${DateFormat('hh aa').format(model.bookingEnd!)}')));
                            context.read<MyAppoinmentsBloc>().add(
                                MyAppointmnetUpdateMeetingEvent(map: model));
                            Navigator.pushNamed(
                                context, AppRoutes.meetingScreen,
                                arguments: MeetingArgumnet(
                                    booking: model,
                                    userId: model.proId!,
                                    email: model.proEmail!,
                                    name: model.proName!,
                                    profileUrl: model.proProfileUrl!));
                          },
                        ))
                    : const SizedBox(),
                model.status! == AppointmentConst.pending
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 40,
                          child: Row(
                            children: [
                              Expanded(
                                child: MyElevatedButton(
                                  btName: 'Cancel',
                                  bgColor: AppPalates.red,
                                  onTap: () {
                                    context.read<MyAppoinmentsBloc>().add(
                                        MyAppointmnetUpdateStatusEvent(
                                            status: AppointmentConst.cancelled,
                                            map: model));
                                    PushNotificationService
                                        .sendNotificationToSelectedUser(
                                            model.userNfToken!,
                                            RemoteMessage(
                                                notification: RemoteNotification(
                                                    title: model.proName,
                                                    body:
                                                        'Appointment Cancelled\n${DateFormat.yMMMEd().format(model.bookingStart!)}, ${DateFormat('hh aa').format(model.bookingStart!)} T0 ${DateFormat('hh aa').format(model.bookingEnd!)}')));
                                  },
                                ),
                              ),
                              const SizedBox(width: 5),
                            ],
                          ),
                        ),
                      )
                    : SizedBox(
                        width: double.infinity,
                        child: model.status == AppointmentConst.completed
                            ? MyElevatedButton(
                                bgColor: AppPalates.green,
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, AppRoutes.sendDocsToUser,
                                      arguments: model);
                                },
                                btName: 'Submit Document',
                              )
                            : const SizedBox(),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
