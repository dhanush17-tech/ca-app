// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
part of 'meeting_bloc.dart';

sealed class MeetingState extends Equatable {
  const MeetingState();

  @override
  List<Object> get props => [];
}

class MeetingInitial extends MeetingState {}

class MeetingLoadingState extends MeetingState {}
class MeetingFailulerState extends MeetingState { String errorMsg;
  MeetingFailulerState({
    required this.errorMsg,
  });}

class MeetingStartedState extends MeetingState {
  BookingTimeModel appointment;
  MeetingStartedState({
    required this.appointment,
  });
}

class MeetingRejectedState extends MeetingState {
  String errorMsg;
  MeetingRejectedState({
    required this.errorMsg,
  });
  
}
class MeetingDoneState extends MeetingState {
  // String errorMsg;
  // MeetingDoneState({
  //   required this.errorMsg,
  // });
  
}
