// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
part of 'booked_appoinments_bloc.dart';

sealed class BookedAppoinmentsState extends Equatable {
  const BookedAppoinmentsState();

  @override
  List<Object> get props => [];
}

final class BookedAppoinmentsInitial extends BookedAppoinmentsState {}

class BookedAppoinmentsLoadingState extends BookedAppoinmentsState {}

class BookedAppoinmentsSuccesState extends BookedAppoinmentsState {
  List<BookingTimeModel> model;
  BookedAppoinmentsSuccesState({
    required this.model,
  });
}

class BookedAppoinmentsFailuerState extends BookedAppoinmentsState {
  String erroMsg;
  BookedAppoinmentsFailuerState(this.erroMsg,
  );
}
