// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
part of 'my_appoinments_bloc.dart';

sealed class MyAppoinmentsEvent extends Equatable {
  const MyAppoinmentsEvent();

  @override
  List<Object> get props => [];
}

class MyAppointmnetFetchEvent extends MyAppoinmentsEvent {}

class MyAppointmnetUpdateMeetingEvent extends MyAppoinmentsEvent {
  BookingTimeModel map;
  MyAppointmnetUpdateMeetingEvent({
    required this.map,
  });
}
class MyAppointmnetUpdateStatusEvent extends MyAppoinmentsEvent {
  BookingTimeModel map;
    String status;
  MyAppointmnetUpdateStatusEvent({
    required this.map,
    required this.status,
  });
}

class MyAppointmnetDeleteEvent extends MyAppoinmentsEvent {
  String appointmentId;
  MyAppointmnetDeleteEvent({
    required this.appointmentId,
  });
}
