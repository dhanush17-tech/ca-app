// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
part of 'professional_account_auth_bloc.dart';

sealed class ProfessionalAccountAuthState extends Equatable {
  const ProfessionalAccountAuthState();

  @override
  List<Object> get props => [];
}

class ProfessionalAccountAuthInitial extends ProfessionalAccountAuthState {}

class ProfessionalAccountAuthLoadingState
    extends ProfessionalAccountAuthState {}

class ProfessionalAccountAuthFailuerState extends ProfessionalAccountAuthState {
  String errorMsg;
  ProfessionalAccountAuthFailuerState({
    required this.errorMsg,
  });
}

class ProfessionalAccountAuthSuccesState extends ProfessionalAccountAuthState {
  ProfessionalAccountModel? professionalAccountModel;
  ProfessionalAccountAuthSuccesState({
     this.professionalAccountModel,
  });
}
