// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
part of 'expense_bloc.dart';

sealed class ExpenseState extends Equatable {
  const ExpenseState();

  @override
  List<Object> get props => [];
}

class ExpenseInitial extends ExpenseState {}

class ExpenseLoadingState extends ExpenseState {}

class ExpenseSuccessState extends ExpenseState {
  ExpenseModel? expenseModel;

  ExpenseSuccessState({
    this.expenseModel,
  });
}

class ExpenseCrudSucccesState extends ExpenseState {
  
}

class ExpenseFailureState extends ExpenseState {
  String errorMsg;
  ExpenseFailureState({
    required this.errorMsg,
  });
}
