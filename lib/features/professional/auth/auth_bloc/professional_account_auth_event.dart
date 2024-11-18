// ignore_for_file: must_be_immutable

part of 'professional_account_auth_bloc.dart';

sealed class ProfessionalAccountAuthEvent extends Equatable {
  const ProfessionalAccountAuthEvent();

  @override
  List<Object> get props => [];
}

class ProfessionalSignUpEvent extends ProfessionalAccountAuthEvent {
  String name;
  String email;
  String password;
  String number;
  String nfToken;
  String accountType;
  ProfessionalSignUpEvent({
    required this.name,
    required this.email,
    required this.number,
    required this.password,
    required this.nfToken,
    required this.accountType,
  });
}

class ProfessionalLoginEvent extends ProfessionalAccountAuthEvent {
  String email;
  String password;
  String nfToken;
  ProfessionalLoginEvent({
    required this.email,
    required this.password,
    required this.nfToken,
  });
}
