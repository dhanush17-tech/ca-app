import 'dart:async';
import 'dart:io';

import 'package:ca_appoinment/features/bookings/model/booking_time_model.dart';
import 'package:ca_appoinment/app/const/firebase_const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

part 'meeting_event.dart';
part 'meeting_state.dart';

class MeetingBloc extends Bloc<MeetingEvent, MeetingState> {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  StreamSubscription? _meetingSubscription;

  MeetingBloc(this.firestore, this.auth) : super(MeetingInitial()) {
    on<MeetingCheckEvent>(_onMeetingCheckEvent);
  }

  Future<void> _onMeetingCheckEvent(
    MeetingCheckEvent event,
    Emitter<MeetingState> emit,
  ) async {
    // emit(MeetingLoadingState());

    try {
      var uId = auth.currentUser!.uid;

      await _meetingSubscription?.cancel(); // Cancel any previous subscriptions

      _meetingSubscription = firestore
          .collection(FirebaseConst.meetingCollection)
          .withConverter<BookingTimeModel>(
            fromFirestore: (snapshot, options) =>
                BookingTimeModel.fromMap(snapshot.data()!),
            toFirestore: (value, options) => value.toMap(),
          )
          .where('userId', isEqualTo: uId)
          .snapshots()
          .listen((snapshot) {
        if (snapshot.docs.isEmpty) {
          if (!emit.isDone) emit(MeetingDoneState());
        } else {
          for (var doc in snapshot.docs) {
            var appointment = doc.data();
            if (!emit.isDone) {
              emit(MeetingStartedState(appointment: appointment));
            }
          }
        }
      });
    } on FirebaseException catch (e) {
      if (!emit.isDone) emit(MeetingFailulerState(errorMsg: e.message!));
    } on SocketException catch (e) {
      if (!emit.isDone) emit(MeetingFailulerState(errorMsg: e.message));
    } catch (e) {
      if (!emit.isDone) emit(MeetingFailulerState(errorMsg: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _meetingSubscription?.cancel();
    return super.close();
  }
}
