import 'dart:io';

import 'package:ca_appoinment/features/bookings/model/booking_time_model.dart';
import 'package:ca_appoinment/app/const/firebase_const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MeetingRepository {
  static var firestore = FirebaseFirestore.instance;
  static var auth = FirebaseAuth.instance;
  static Stream<QuerySnapshot<BookingTimeModel>> meetingListener() {
    late Stream<QuerySnapshot<BookingTimeModel>> snap;
    try {
      snap = firestore
          .collection(FirebaseConst.meetingCollection)
          .withConverter<BookingTimeModel>(
            fromFirestore: (snapshot, options) =>
                BookingTimeModel.fromMap(snapshot.data()!),
            toFirestore: (value, options) => value.toMap(),
          )
          .where('userId', isEqualTo: auth.currentUser!.uid)
          .snapshots();
    } on FirebaseException catch (e) {
      throw Exception(e.message);
    }on SocketException catch (e) {
      throw Exception(e.message);
    }catch (e) {
      throw Exception(e);
    }
    return snap;
  }
}
