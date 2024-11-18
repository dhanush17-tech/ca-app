// ignore_for_file: must_be_immutable

part of 'ca_account_bloc.dart';

sealed class CaAccountState extends Equatable {
  const CaAccountState();
  
  @override
  List<Object> get props => [];
}

final class CaAccountInitial extends CaAccountState {}

class CaAccountsLoadingState extends CaAccountState {}

class CaAccountsSuccesState extends CaAccountState {
  List<ProfessionalAccountModel> accounts;
  CaAccountsSuccesState({
    required this.accounts,
  });
}

class CaAccountsFailuerState extends CaAccountState {
  String errorMsg;
  CaAccountsFailuerState({
    required this.errorMsg,
  });
}
