// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
part of 'clients_bloc.dart';

sealed class ClientsState extends Equatable {
  const ClientsState();

  @override
  List<Object> get props => [];
}

final class ClientsInitial extends ClientsState {}

class ClientsLoadingState extends ClientsState {}

class ClientsSuccesState extends ClientsState {
  List<UserModel> clients;
  ClientsSuccesState({
    required this.clients,
  });
}

class ClientsFailuerState extends ClientsState {
  String errorMsg;
  ClientsFailuerState({
    required this.errorMsg,
  });
}
