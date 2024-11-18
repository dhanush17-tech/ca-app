import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ca_appoinment/features/bookings/model/booking_time_model.dart';
import 'package:ca_appoinment/app/const/firebase_const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'booked_appoinments_event.dart';
part 'booked_appoinments_state.dart';

class BookedAppoinmentsBloc
    extends Bloc<BookedAppoinmentsEvent, BookedAppoinmentsState> {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  BookedAppoinmentsBloc(this.firestore, this.auth)
      : super(BookedAppoinmentsInitial()) {
         List<BookingTimeModel> sortBookingsByDate(
            List<BookingTimeModel> bookings) {
          bookings.sort((a, b) => a.bookingStart!.compareTo(b.bookingStart!));
          return bookings;
        }
    on<BookedAppointmentFetchEvent>((event, emit) async {
      emit(BookedAppoinmentsLoadingState());
      try {
        List<BookingTimeModel> booked = [];
        String userId = auth.currentUser!.uid;
        var proColect =
            firestore.collection(FirebaseConst.professionCollection);

        var proUserData = await proColect.get();
       

        for (var each in proUserData.docs) {
          var bookingCollection = firestore
              .collection(FirebaseConst.professionCollection)
              .doc(each.data()['userId'])
              .collection(FirebaseConst.bookingCollection)
              .withConverter<BookingTimeModel>(
                fromFirestore: (snapshots, _) =>
                    BookingTimeModel.fromMap(snapshots.data()!),
                toFirestore: (model, _) => model.toMap(),
              );

          var bookings =
              await bookingCollection.where('userId', isEqualTo: userId).get();

          for (var doc in bookings.docs) {
            booked.add(doc.data());
          }
        }
        booked = sortBookingsByDate(booked);
        emit(BookedAppoinmentsSuccesState(model: booked.reversed.toList()));
      } on FirebaseAuthException catch (e) {
        emit(BookedAppoinmentsFailuerState(e.message!));
      } on SocketException catch (e) {
        emit(BookedAppoinmentsFailuerState(e.message));
      } catch (e) {
        emit(BookedAppoinmentsFailuerState(e.toString()));
      }
    });
  }
}
