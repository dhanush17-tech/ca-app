// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'credit_bloc.dart';

sealed class CreditState extends Equatable {
  const CreditState();

  @override
  List<Object> get props => [];
}

final class CreditInitial extends CreditState {}

class CreditLoadingState extends CreditState {}

class CreditSuccesState extends CreditState {
  CreditBalanceModel model;
  
  CreditSuccesState({
    required this.model,    // required this.creditModel
  });
}

class CreditFailureState extends CreditState {
  String errorMsg;
  CreditFailureState({
    required this.errorMsg,
  });
}

class CreditBuySuccesState extends CreditState {
  Map<String, dynamic> option;
  CreditBuySuccesState({
    required this.option,
  });
}
