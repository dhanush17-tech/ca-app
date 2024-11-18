// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
part of 'my_appoinments_bloc.dart';

sealed class MyAppoinmentsState extends Equatable {
  const MyAppoinmentsState();

  @override
  List<Object> get props => [];
}

final class MyAppoinmentsInitial extends MyAppoinmentsState {}

class MyAppoinmentsLoadingState extends MyAppoinmentsState {}

class MyAppoinmentsSuccesState extends MyAppoinmentsState {
  List<BookingTimeModel> allAppoinmnets;
  List<BookingTimeModel> pending;
  MyAppoinmentsSuccesState({
    required this.allAppoinmnets,
    required this.pending,
  });
}

class MyAppoinmentsFailuerState extends MyAppoinmentsState {
  String errorMsg;
  MyAppoinmentsFailuerState({
    required this.errorMsg,
  });
}
