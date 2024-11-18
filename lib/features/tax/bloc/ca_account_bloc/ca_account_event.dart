part of 'ca_account_bloc.dart';

sealed class CaAccountEvent extends Equatable {
  const CaAccountEvent();

  @override
  List<Object> get props => [];
}

class CaAccountsFetchEvent extends CaAccountEvent {}
