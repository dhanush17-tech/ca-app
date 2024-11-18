// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthLoginEvent extends AuthEvent {
  String email;
  String password;
  String nfToken;
  AuthLoginEvent({
    required this.email,
    required this.password,
    required this.nfToken,
  });
}

class AuthSignUpEvent extends AuthEvent {
  String name;
  String email; 
  String password;
  String nfToken;
  AuthSignUpEvent({
    required this.name,
    required this.nfToken,
    required this.email,
    required this.password,
  });
}

class AuthLogOutEvent extends AuthEvent {}

class AuthForgetPasswordEvent extends AuthEvent {
  String email;
  AuthForgetPasswordEvent({
    required this.email,
  });
}

class AuthChangePasswordEvent extends AuthEvent {
  String oldPassword;
  String newPassword;
  AuthChangePasswordEvent({
    required this.oldPassword,
    required this.newPassword,
  });
}
