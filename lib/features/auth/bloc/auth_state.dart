// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthSuccesState extends AuthState {
  UserModel? userModel;
  String? userType;
  AuthSuccesState({
    this.userModel,
    this.userType,
  });
}

class AuthUpdatePassSuccess extends AuthState {
  String succesMsg;
  AuthUpdatePassSuccess({
    required this.succesMsg,
  });
}

class AuthFailureState extends AuthState {
  String errorMsg;
  AuthFailureState({
    required this.errorMsg,
  });
}

class AuthPassUpdateFailureState extends AuthState {
  String errorMsg;
  AuthPassUpdateFailureState({
    required this.errorMsg,
  });
}
