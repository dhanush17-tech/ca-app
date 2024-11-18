import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ca_appoinment/features/bookings/model/booking_time_model.dart';
import 'package:ca_appoinment/app/const/book_appointment_cont.dart';
import 'package:ca_appoinment/app/const/firebase_const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'my_appoinments_event.dart';
part 'my_appoinments_state.dart';

class MyAppoinmentsBloc extends Bloc<MyAppoinmentsEvent, MyAppoinmentsState> {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  MyAppoinmentsBloc(this.firestore, this.auth) : super(MyAppoinmentsInitial()) {
    on<MyAppointmnetFetchEvent>((event, emit) async {
      List<BookingTimeModel> allAppointments = [];
      List<BookingTimeModel> pendingAppointments = [];
      emit(MyAppoinmentsLoadingState());
      try {
        await firestore
            .collection(FirebaseConst.professionCollection)
            .doc(auth.currentUser!.uid)
            .collection(FirebaseConst.bookingCollection)
            .orderBy('bookingStart', descending: true)
            .withConverter<BookingTimeModel>(
              fromFirestore: (snapshot, options) =>
                  BookingTimeModel.fromMap(snapshot.data()!),
              toFirestore: (value, options) => value.toMap(),
            )
            .get()
            .then((event) {
          for (var each in event.docs) {
            allAppointments.add(each.data());
            if (each.data().status == AppointmentConst.pending) {
              pendingAppointments.add(each.data());
            }
          }
          emit(MyAppoinmentsSuccesState(
              allAppoinmnets: allAppointments, pending: pendingAppointments));
        });
      } on FirebaseException catch (e) {
        emit(MyAppoinmentsFailuerState(errorMsg: e.message!));
      } on SocketException catch (e) {
        emit(MyAppoinmentsFailuerState(errorMsg: e.message));
      } catch (e) {
        emit(MyAppoinmentsFailuerState(errorMsg: e.toString()));
      }
    });

    on<MyAppointmnetUpdateMeetingEvent>(
      (event, emit) async {
        try {
          await firestore
              .collection(FirebaseConst.meetingCollection)
              .doc(event.map.userId!)
              .collection('started')
              .add(event.map.toMap());
          add(MyAppointmnetUpdateStatusEvent(
              map: event.map, status: 'Started'));
          add(MyAppointmnetFetchEvent());
        } on FirebaseException catch (e) {
          emit(MyAppoinmentsFailuerState(errorMsg: e.message!));
        } on SocketException catch (e) {
          emit(MyAppoinmentsFailuerState(errorMsg: e.message));
        } catch (e) {
          emit(MyAppoinmentsFailuerState(errorMsg: e.toString()));
        }
      },
    );
    on<MyAppointmnetUpdateStatusEvent>(
      (event, emit) async {
        try {
          await firestore
              .collection(FirebaseConst.professionCollection)
              .doc(event.map.proId!)
              .collection(FirebaseConst.bookingCollection)
              .doc(event.map.serviceID)
              .update({'status': event.status});
          add(MyAppointmnetFetchEvent());
        } on FirebaseException catch (e) {
          emit(MyAppoinmentsFailuerState(errorMsg: e.message!));
        } on SocketException catch (e) {
          emit(MyAppoinmentsFailuerState(errorMsg: e.message));
        } catch (e) {
          emit(MyAppoinmentsFailuerState(errorMsg: e.toString()));
        }
      },
    );
  }
}
