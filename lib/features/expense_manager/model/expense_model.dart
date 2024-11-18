// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:ca_appoinment/features/expense_manager/model/categories_model.dart';
import 'package:ca_appoinment/features/expense_manager/model/month_wise_model.dart';
import 'package:ca_appoinment/features/expense_manager/model/transaction_model.dart';

class ExpenseModel {
  String id;
  List<TransactionModel>? transactions;
  String income;
  String expense;
  Map<String, List<TransactionModel>> dateWiseExpenses;
  List<MonthModel>? monthWiseTransactions;
  List<MonthModel>? weekdayWiseTransactions;
  List<CategoryModel>? categoryWiseExpense;
  ExpenseModel(
      {required this.id,
      this.transactions,
      required this.income,
      required this.expense,
     required this.categoryWiseExpense,
     required this.dateWiseExpenses,
     required this.monthWiseTransactions,
     required this.weekdayWiseTransactions,
      });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'transactions': transactions?.map((x) => x.toMap()).toList(),
      'income': income,
      'expense': expense,
      'dateWiseExpense': dateWiseExpenses,
      'categoryWiseExpense':categoryWiseExpense,
      'weekdayWiseTransactions':weekdayWiseTransactions,
      'monthWiseTransactions':monthWiseTransactions
    };
  }

  factory ExpenseModel.fromMap(Map<String, dynamic> map) {
    return ExpenseModel(
        id: map['id'] as String,
        transactions: List<TransactionModel>.from(
          (map['transactions'] as List<int>).map<TransactionModel>(
            (x) => TransactionModel.fromMap(x as Map<String, dynamic>),
          ),
        ),
        income: map['income'] as String,
        expense: map['expense'] as String,
        categoryWiseExpense: map['categoryWiseExpense'] ,
        weekdayWiseTransactions: map['weekdayWiseTransactions'] ,
        monthWiseTransactions: map['monthWiseTransactions'] ,
        dateWiseExpenses: map['dateWiseExpenses']);
  }
}
