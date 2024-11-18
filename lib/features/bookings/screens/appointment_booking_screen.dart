// ignore_for_file: unused_field, must_be_immutable

import 'package:ca_appoinment/app/routes/app_routes.dart';
import 'package:ca_appoinment/app/theme/color.dart';
import 'package:ca_appoinment/app/widgets/my_card_widget.dart';
import 'package:ca_appoinment/app/widgets/my_elevated_button.dart';
import 'package:ca_appoinment/app/widgets/my_icon_pop_button.dart';
import 'package:ca_appoinment/features/professional/profile/models/pro_account_model.dart';
import 'package:ca_appoinment/features/tax/widgets/tax_app_bar.dart';
import 'package:ca_appoinment/features/user/blocs/user_bloc/user_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../app/widgets/ca_profile.dart';
import '../widgets/my_booking_date_and_time_widget.dart';
// import 'package:date_time_picker_widget/date_time_picker_widget.dart';
// import 'package:easy_date_timeline/easy_date_timeline.dart';
// import 'package:intl/intl.dart';
// import 'package:time_slot/model/time_slot_Interval.dart';
// import 'package:time_slot/time_slot_from_interval.dart';

class AppointmentBookingScreen extends StatefulWidget {
  const AppointmentBookingScreen({super.key});

  @override
  State<AppointmentBookingScreen> createState() =>
      _AppointmentStateBookingScreen();
}

class _AppointmentStateBookingScreen extends State<AppointmentBookingScreen> {
  ProfessionalAccountModel? model;

  final DateTime _currentDate = DateTime.now();
  // DateTime nowDate = DateTime.now();
  final DateTime _selectTime = DateTime.now();
  TextEditingController noteController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late FirebaseAuth auth;
  String userId = '';
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var arg = ModalRoute.of(context)!.settings.arguments;
      context.read<UserBloc>().add(FetchProfileEvent());
      if (arg is ProfessionalAccountModel) {
        setState(() {
          auth = FirebaseAuth.instance;
          model = arg;
          userId = auth.currentUser!.uid;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (model == null) {
      return Scaffold(
        appBar: myTaxAppBar('Book Appointment'),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppPalates.primary,
        surfaceTintColor: AppPalates.primary,
        leading: const Padding(
          padding: EdgeInsets.all(3),
          child: MyIconPopButton(),
        ),
        title: const Text(
          'Book Appointment',
          style:
              TextStyle(fontWeight: FontWeight.bold, color: AppPalates.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CaProfile(model: model),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Doc required Title
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: MyCardWidget(
                    elevation: 0,
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Document Required After Meeting',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppPalates.red,
                            fontSize: 17),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                //Note TextField
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Enter Requirements',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppPalates.black,
                        fontSize: 18),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: TextField(
                    controller: noteController,
                    maxLength: 500,
                    maxLines: null,
                    onChanged: (value) {
                      setState(() {
                        noteController.text = value;
                      });
                    },
                    cursorColor: AppPalates.primary,
                    buildCounter: (
                      BuildContext context, {
                      required int currentLength,
                      required bool isFocused,
                      required int? maxLength,
                    }) {
                      return Text(
                        '$currentLength / $maxLength',
                        style: const TextStyle(color: AppPalates.black),
                      );
                    },
                    decoration: InputDecoration(
                        hintText: 'Type Here....',
                        border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: AppPalates.primary, width: 3),
                            borderRadius: BorderRadius.circular(12))),
                  ),
                ),
                // const SizedBox(height: 20),
                checkCredits(),
                const SizedBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }

  checkCredits() {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserSuccessState) {
          if (state.userModel.credit == 0) {
            return Center(
              child: MyCardWidget(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      const Text(
                        'You Need 1 Credit For\n Book Appointment',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppPalates.red,
                            fontSize: 18),
                      ),
                      MyElevatedButton(
                          btName: 'Buy Credit',
                          onTap: () {
                            Navigator.pushNamed(context, AppRoutes.creditScreen,
                                arguments: state.userModel);
                          }),
                    ],
                  ),
                ),
              ),
            );
          }
          return SizedBox(
              height: 650,
              child: MyBookingDateAndTimeWidget(
                model: model!,
                requirements: noteController.text,
              ));
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
