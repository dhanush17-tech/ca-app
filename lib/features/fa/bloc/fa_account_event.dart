part of 'fa_account_bloc.dart';

sealed class FaAccountEvent extends Equatable {
  const FaAccountEvent();

  @override
  List<Object> get props => [];
}

class FaAccountFetchEvent extends FaAccountEvent{}