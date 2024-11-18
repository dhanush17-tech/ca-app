import 'package:booking_calendar/booking_calendar.dart';
import 'package:ca_appoinment/app/core/push_notification_service.dart';
import 'package:ca_appoinment/features/credit/blocs/credit_bloc/credit_bloc.dart';
import 'package:ca_appoinment/features/credit/model/credit_model.dart';
import 'package:ca_appoinment/features/user/model/user_model.dart';
import 'package:ca_appoinment/app/const/book_appointment_cont.dart';
import 'package:ca_appoinment/app/const/firebase_const.dart';

import 'package:ca_appoinment/features/bookings/model/booking_time_model.dart';
import 'package:ca_appoinment/features/professional/profile/models/pro_account_model.dart';
import 'package:ca_appoinment/features/tax/screens/booked_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class BookAppointmentRepository {
  static CollectionReference bookings =
      FirebaseFirestore.instance.collection(FirebaseConst.professionCollection);
  static CollectionReference userCollect =
      FirebaseFirestore.instance.collection(FirebaseConst.userCollection);
  static var firestore = FirebaseFirestore.instance;
  static CollectionReference<BookingTimeModel> getBookingStream({
    required ProfessionalAccountModel proModel,
  }) {
    return bookings
        .doc(proModel.userId!)
        .collection(FirebaseConst.bookingCollection)
        .withConverter<BookingTimeModel>(
          fromFirestore: (snapshots, _) =>
              BookingTimeModel.fromMap(snapshots.data()!),
          toFirestore: (snapshots, _) => snapshots.toMap(),
        );
  }

  static Stream<dynamic>? getBookingStreamFirebase({
    required DateTime end,
    required DateTime start,
    required ProfessionalAccountModel proModel,
  }) {
    var snap = getBookingStream(proModel: proModel).snapshots();

    return snap;
  }

  static List<DateTimeRange> convertStreamResultFirebase(
      {required QuerySnapshot<BookingTimeModel> streamResult}) {
    List<DateTimeRange> converted = [];
    for (var each in streamResult.docs) {
      BookingTimeModel model = each.data();
      converted.add(
          DateTimeRange(start: model.bookingStart!, end: model.bookingEnd!));
    }
    return converted;
  }

  ///This is how you upload data to Firestore
  static Future<dynamic> uploadBookingFirebase(
      {required ProfessionalAccountModel proModel,
      required String requirements,
      required BookingService newBooking,
      required BuildContext context}) async {
    await FirebaseFirestore.instance
        .collection(FirebaseConst.userCollection)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((userData) async {
      var userModel = UserModel.fromMap(userData.data()!);

      var model = BookingTimeModel(
        //user
        proId: proModel.userId,
        proName: proModel.userName,
        proPhoneNumber: proModel.phoneNumber,
        proEmail: proModel.email,
        proNfToken: proModel.nfToken,
        proProfileUrl: proModel.profileUrl,
        // booking details
        serviceID: newBooking.serviceId,
        serviceName: newBooking.serviceName,
        serviceDuration: newBooking.serviceDuration,
        servicePrice: newBooking.servicePrice,
        //timestamp
        bookingEnd: newBooking.bookingEnd,
        bookingStart: newBooking.bookingStart,
        //user Details
        userId: userModel.uId,
        userName: userModel.name,
        userPhoneNumber: userModel.number,
        userEmail: userModel.email,
        userProfileUrl: userModel.profilePic,
        requirements: requirements,
        userNfToken: userModel.nfToken,

        status: AppointmentConst.pending,
      );
      await firestore
          .collection(FirebaseConst.professionCollection)
          .doc(proModel.userId)
          .collection(FirebaseConst.bookingCollection)
          .doc(newBooking.serviceId)
          .set(model.toMap())
          .then((value) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return const BookingSuccesDialog();
          },
        );
//Decrease The Credit on  Appointment book Succes

        context.read<CreditBloc>().add(CreditUseEvent(
            creditModel: CreditModel(
                amount: 100,
                credit: 1,
                email: model.userEmail!,
                name: model.userName!,
                number: model.userPhoneNumber!,
                increase: false,
                uId: model.userId!,
                orderId: model.serviceID!,
                purchaseTime: DateTime.now().millisecondsSinceEpoch)));

// Sending Notification to Professtional Account
        PushNotificationService.sendNotificationToSelectedUser(
            model.proNfToken!,
            RemoteMessage(
                notification: RemoteNotification(
                    title: model.userName,
                    body:
                        'Booked Appointment\nTime :- ${DateFormat.MMMEd().format(model.bookingStart!)}, ${DateFormat('hh:mm:aa').format(model.bookingStart!)}')));
// Sechdule Notification For User
        PushNotificationService.secduleNotification(
            RemoteMessage(
                notification: RemoteNotification(
              title: model.userName,
              body:
                  'Booked Appointment\nTime :- ${DateFormat.MMMEd().format(model.bookingStart!)}, ${DateFormat('hh:mm:aa').format(model.bookingStart!)}',
            )),
            model.bookingStart!.millisecondsSinceEpoch);
      });
    });
  }
}
