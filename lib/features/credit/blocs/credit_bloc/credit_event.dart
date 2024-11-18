// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'credit_bloc.dart';

sealed class CreditEvent extends Equatable {
  const CreditEvent();

  @override
  List<Object> get props => [];
}

class CreditBuyEvent extends CreditEvent {
  int credit;
  int amount;
  CreditBuyEvent({
    required this.credit,
    required this.amount,
  });
}

class CreditUseEvent extends CreditEvent {
  CreditModel? creditModel;

  CreditUseEvent({
    required this.creditModel,
  });
}

class CreditFetchEvent extends CreditEvent {}

class CreditUpdateEvent extends CreditEvent {
  String orderId;
  CreditUpdateEvent({
    required this.orderId,
  });
}
