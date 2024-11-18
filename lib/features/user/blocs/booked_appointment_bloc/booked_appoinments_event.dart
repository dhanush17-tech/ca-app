part of 'booked_appoinments_bloc.dart';

sealed class BookedAppoinmentsEvent extends Equatable {
  const BookedAppoinmentsEvent();

  @override
  List<Object> get props => [];
}

class BookedAppointmentFetchEvent extends BookedAppoinmentsEvent {
  
}
