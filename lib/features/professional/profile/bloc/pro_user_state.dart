// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
part of 'pro_user_bloc.dart';

sealed class ProUserState extends Equatable {
  const ProUserState();

  @override
  List<Object> get props => [];
}

class ProUserInitial extends ProUserState {}

class ProUserLoadingState extends ProUserState {}

class ProUserSuccessState extends ProUserState {
  ProfessionalAccountModel proModel;
  ProUserSuccessState({
    required this.proModel,
  });
}

class ProUserFailuerState extends ProUserState {
  String errorMsg;
  ProUserFailuerState({
    required this.errorMsg,
  });
}
