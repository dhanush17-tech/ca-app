import 'package:ca_appoinment/features/expense_manager/model/transaction_model.dart';

class MonthModel {
  final int id;
  final String title;
  final List<TransactionModel>? transactions;
  final int totalIncome;
  final int totalExpense;

  MonthModel({
    required this.id,
    required this.title,
    this.transactions,
    this.totalIncome = 0,
    this.totalExpense = 0,
  });

  MonthModel copyWith({
    int? id,
    String? title,
    List<TransactionModel>? transactions,
    int? totalIncome,
    int? totalExpense,
  }) {
    return MonthModel(
      id: id ?? this.id,
      title: title ?? this.title,
      transactions: transactions ?? this.transactions,
      totalIncome: totalIncome ?? this.totalIncome,
      totalExpense: totalExpense ?? this.totalExpense,
    );
  }
}
