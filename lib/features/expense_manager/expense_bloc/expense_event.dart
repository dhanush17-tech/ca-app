// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
part of 'expense_bloc.dart';

sealed class ExpenseEvent extends Equatable {
  const ExpenseEvent();

  @override
  List<Object> get props => [];
}

class AddExpenseEvent extends ExpenseEvent {
  TransactionModel transactionModel;

  AddExpenseEvent({
    required this.transactionModel,
  });
}

class UpdateExpenseEvent extends ExpenseEvent {
  TransactionModel transaction;
  UpdateExpenseEvent({
    required this.transaction,
  });
}

class DeleteExpenseEvent extends ExpenseEvent {
  TransactionModel transaction;
  DeleteExpenseEvent({
    required this.transaction,
  });
}

class FetchExpenseEvent extends ExpenseEvent {}
