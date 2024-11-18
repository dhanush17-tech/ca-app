// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
part of 'fa_account_bloc.dart';

sealed class FaAccountState extends Equatable {
  const FaAccountState();

  @override
  List<Object> get props => [];
}

final class FaAccountInitial extends FaAccountState {}

class FaAccountLoadingState extends FaAccountState {}

class FaAccountSuccesState extends FaAccountState {
  List<ProfessionalAccountModel> accounts;
  FaAccountSuccesState({
    required this.accounts,
  });
}

class FaAccountFailuerState extends FaAccountState {
  String errorMsg;
  FaAccountFailuerState({
    required this.errorMsg,
  });
}
