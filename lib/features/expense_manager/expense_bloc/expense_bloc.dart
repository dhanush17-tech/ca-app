import 'dart:async';
import 'dart:io';

import 'package:ca_appoinment/app/const/firebase_const.dart';
import 'package:ca_appoinment/app/function/appoinment_id_gen.dart';
import 'package:ca_appoinment/features/expense_manager/model/categories_model.dart';
import 'package:ca_appoinment/features/expense_manager/model/expense_model.dart';
import 'package:ca_appoinment/features/expense_manager/model/month_wise_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ca_appoinment/features/expense_manager/model/transaction_model.dart';
import 'package:equatable/equatable.dart';

part 'expense_event.dart';
part 'expense_state.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ExpenseBloc({required this.firestore, required this.auth})
      : super(ExpenseInitial()) {
    on<FetchExpenseEvent>(_fetchExpenseEvent);
    on<AddExpenseEvent>(_addExpenseEvent);
    on<UpdateExpenseEvent>(_updateExpenseEvent);
    on<DeleteExpenseEvent>(_deleteExpenseEvent);
  }

  Future<ExpenseModel> fetchExpense() async {
    List<TransactionModel> listTransaction = [];
    var totalIncome = 0;
    var totalExpense = 0;

    List<CategoryModel> categoryModel = [];
    Map<String, List<TransactionModel>> dateWiseTransaction = {
      'today': [],
      'yesterday': [],
      'this month': [],
      'this year': [],
      'else': [],
    };
    Map<int, List<TransactionModel>> monthWiseTransactions = {};
    Map<int, int> monthWiseIncome = {};
    Map<int, int> monthWiseExpense = {};

    String userId = auth.currentUser!.uid;
    var transationCollection = firestore
        .collection(FirebaseConst.userCollection)
        .doc(userId)
        .collection(FirebaseConst.transationCollection);

    var transationData =
        await transationCollection.orderBy('createAt', descending: true).get();
    var transationWithLatestDate =
        await transationCollection.orderBy('createAt', descending: false).get();
    for (var eachTransation in transationWithLatestDate.docs) {
      var transactionModel = TransactionModel.fromMap(eachTransation.data());
      var date = DateTime.fromMillisecondsSinceEpoch(
          int.parse(transactionModel.createAt));

      // Month-Wise Transactions
      var month = date.month;
      monthWiseTransactions.putIfAbsent(month, () => []);
      monthWiseTransactions[month]!.add(transactionModel);

      // Month-Wise Income and Expense
      if (transactionModel.income) {
        monthWiseIncome[month] =
            (monthWiseIncome[month] ?? 0) + int.parse(transactionModel.amount);
      } else {
        monthWiseExpense[month] =
            (monthWiseExpense[month] ?? 0) + int.parse(transactionModel.amount);
      }
    }
    for (var eachTransation in transationData.docs) {
      var transactionModel = TransactionModel.fromMap(eachTransation.data());
      listTransaction.add(transactionModel);

      // Only For income and Expense
      if (transactionModel.income) {
        totalIncome += int.parse(transactionModel.amount);
      } else {
        totalExpense += int.parse(transactionModel.amount);
      }

      // Format DateWise Transaction and TimeStamp

      var date = DateTime.fromMillisecondsSinceEpoch(
          int.parse(transactionModel.createAt));

      if (DateTime.now().day == date.day) {
        dateWiseTransaction['today']!.add(transactionModel);
      } else if ((DateTime.now().day - 1).toString() == date.day.toString()) {
        dateWiseTransaction['yesterday']!.add(transactionModel);
      } else if ((DateTime.now().month).toString() == date.month.toString()) {
        dateWiseTransaction['this month']!.add(transactionModel);
      } else if ((DateTime.now().year).toString() == date.year.toString()) {
        dateWiseTransaction['this year']!.add(transactionModel);
      }

      // Update category-wise income and expense
      var category = transactionCategory.firstWhere(
          (cat) => cat.id == transactionModel.categoryId,
          orElse: () =>
              CategoryModel(id: transactionModel.categoryId, title: 'Unknown'));
      var existingCategoryIndex =
          categoryModel.indexWhere((cat) => cat.id == category.id);

      if (existingCategoryIndex >= 0) {
        var existingCategory = categoryModel[existingCategoryIndex];
        var updatedTransactions =
            List<TransactionModel>.from(existingCategory.transactions ?? [])
              ..add(transactionModel);

        var updatedIncome = existingCategory.income;
        var updatedExpense = existingCategory.expense;
        if (transactionModel.income) {
          updatedIncome += int.parse(transactionModel.amount);
        } else {
          updatedExpense += int.parse(transactionModel.amount);
        }

        categoryModel[existingCategoryIndex] = existingCategory.copyWith(
          transactions: updatedTransactions,
          income: updatedIncome,
          expense: updatedExpense,
        );
      } else {
        categoryModel.add(category.copyWith(
          transactions: [transactionModel],
          income:
              transactionModel.income ? int.parse(transactionModel.amount) : 0,
          expense:
              transactionModel.income ? 0 : int.parse(transactionModel.amount),
        ));
      }
    }
    var monthTitle = '';
    List<MonthModel> formattedMonthWiseTransactions = [];
    for (var month in monthWiseTransactions.keys) {
      switch (month) {
        case 1:
          monthTitle = 'Jan';
        case 2:
          monthTitle = 'Feb';
        case 3:
          monthTitle = 'Mar';
        case 4:
          monthTitle = 'Apr';
        case 5:
          monthTitle = 'May';
        case 6:
          monthTitle = 'Jun';
        case 7:
          monthTitle = 'Jul';
        case 8:
          monthTitle = 'Aug';
        case 9:
          monthTitle = 'Sep';
        case 10:
          monthTitle = 'Oct';
        case 11:
          monthTitle = 'Nov';
        case 12:
          monthTitle = 'Dec';
      }
      formattedMonthWiseTransactions.add(MonthModel(
        id: month,
        title: monthTitle, // Set the appropriate title if needed
        transactions: monthWiseTransactions[month],
        totalIncome: monthWiseIncome[month] ?? 0,
        totalExpense: monthWiseExpense[month] ?? 0,
      ));
    }

    return ExpenseModel(
      expense: totalExpense.toString(),
      income: totalIncome.toString(),
      id: userId,
      dateWiseExpenses: dateWiseTransaction,
      transactions: listTransaction,
      categoryWiseExpense: categoryModel,
      monthWiseTransactions: formattedMonthWiseTransactions,
      weekdayWiseTransactions: formattedMonthWiseTransactions,
    );
  }

  FutureOr<void> _fetchExpenseEvent(
      FetchExpenseEvent event, Emitter<ExpenseState> emit) async {
    emit(ExpenseLoadingState());
    try {
      var expenseModel = await fetchExpense();
      if (expenseModel.transactions != null) {
        emit(ExpenseSuccessState(expenseModel: expenseModel));
      }
    } on FirebaseAuthException catch (e) {
      emit(ExpenseFailureState(errorMsg: e.message!));
    } on SocketException catch (e) {
      emit(ExpenseFailureState(errorMsg: e.message));
    } catch (e) {
      emit(ExpenseFailureState(errorMsg: e.toString()));
    }
  }

  FutureOr<void> _addExpenseEvent(
      AddExpenseEvent event, Emitter<ExpenseState> emit) async {
    emit(ExpenseLoadingState());
    try {
      String userId = auth.currentUser!.uid;
      var uuid = IdGenerator.transactionID();
      TransactionModel transaction = TransactionModel(
          id: uuid,
          title: event.transactionModel.title,
          categoryId: event.transactionModel.categoryId,
          createAt: event.transactionModel.createAt,
          amount: event.transactionModel.amount,
          income: event.transactionModel.income);
      await firestore
          .collection(FirebaseConst.userCollection)
          .doc(userId)
          .collection(FirebaseConst.transationCollection)
          .doc(uuid)
          .set(transaction.toMap())
          .then((value) {
        emit(ExpenseCrudSucccesState());
      });

      var expenseModel = await fetchExpense();

      if (expenseModel.transactions != null) {
        emit(ExpenseSuccessState(expenseModel: expenseModel));
      }
    } on FirebaseAuthException catch (e) {
      emit(ExpenseFailureState(errorMsg: e.message!));
    } on SocketException catch (e) {
      emit(ExpenseFailureState(errorMsg: e.message));
    } catch (e) {
      emit(ExpenseFailureState(errorMsg: e.toString()));
    }
  }

  FutureOr<void> _updateExpenseEvent(
      UpdateExpenseEvent event, Emitter<ExpenseState> emit) async {
    emit(ExpenseLoadingState());
    try {
      String userId = auth.currentUser!.uid;
      await firestore
          .collection(FirebaseConst.userCollection)
          .doc(userId)
          .collection(FirebaseConst.transationCollection)
          .doc(event.transaction.id)
          .update(event.transaction.toMap());
      emit(ExpenseCrudSucccesState());

      var expenseModel = await fetchExpense();

      if (expenseModel.transactions != null) {
        emit(ExpenseSuccessState(expenseModel: expenseModel));
      }
    } on FirebaseAuthException catch (e) {
      emit(ExpenseFailureState(errorMsg: e.message!));
    } on SocketException catch (e) {
      emit(ExpenseFailureState(errorMsg: e.message));
    } catch (e) {
      emit(ExpenseFailureState(errorMsg: e.toString()));
    }
  }

  FutureOr<void> _deleteExpenseEvent(
      DeleteExpenseEvent event, Emitter<ExpenseState> emit) async {
    try {
      String userId = auth.currentUser!.uid;
      await firestore
          .collection(FirebaseConst.userCollection)
          .doc(userId)
          .collection(FirebaseConst.transationCollection)
          .doc(event.transaction.id)
          .delete();

      var expenseModel = await fetchExpense();

      if (expenseModel.transactions != null) {
        emit(ExpenseSuccessState(expenseModel: expenseModel));
      }
    } on FirebaseAuthException catch (e) {
      emit(ExpenseFailureState(errorMsg: e.message!));
    } on SocketException catch (e) {
      emit(ExpenseFailureState(errorMsg: e.message));
    } catch (e) {
      emit(ExpenseFailureState(errorMsg: e.toString()));
    }
  }
}
// import 'dart:async';
// import 'dart:io';

// import 'package:ca_appoinment/app/const/firebase_const.dart';
// import 'package:ca_appoinment/app/function/appoinment_id_gen.dart';
// import 'package:ca_appoinment/features/expense_manager/model/categories_model.dart';
// import 'package:ca_appoinment/features/expense_manager/model/expense_model.dart';
// import 'package:ca_appoinment/features/expense_manager/model/month_wise_model.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:ca_appoinment/features/expense_manager/model/transaction_model.dart';
// import 'package:equatable/equatable.dart';

// part 'expense_event.dart';
// part 'expense_state.dart';

// class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
//   final FirebaseFirestore firestore;
//   final FirebaseAuth auth;

//   ExpenseBloc({required this.firestore, required this.auth})
//       : super(ExpenseInitial()) {
//     on<FetchExpenseEvent>(_fetchExpenseEvent);
//     on<AddExpenseEvent>(_addExpenseEvent);
//     on<UpdateExpenseEvent>(_updateExpenseEvent);
//     on<DeleteExpenseEvent>(_deleteExpenseEvent);
//   }

//   Future<ExpenseModel> fetchExpense() async {
//     List<TransactionModel> listTransaction = [];
//     var totalIncome = 0;
//     var totalExpense = 0;

//     List<CategoryModel> categoryModel = [];
//     Map<String, List<TransactionModel>> dateWiseTransaction = {
//       'today': [],
//       'yesterday': [],
//       'this month': [],
//       'this year': [],
//       'else': [],
//     };
//     List<MonthModel> monthWiseTransactions = [];
//     Map<String, List<TransactionModel>> weekdayWiseTransactions = {
//       'Monday': [],
//       'Tuesday': [],
//       'Wednesday': [],
//       'Thursday': [],
//       'Friday': [],
//       'Saturday': [],
//       'Sunday': [],
//     };

//     String userId = auth.currentUser!.uid;
//     var transationCollection = firestore
//         .collection(FirebaseConst.userCollection)
//         .doc(userId)
//         .collection(FirebaseConst.transationCollection)
//         .orderBy('createAt', descending: true);

//     var transationData = await transationCollection.get();
//     var limitData = await transationCollection.limit(12).get();
//     for (var limitCollection in limitData.docs) {
//       var limitModel = TransactionModel.fromMap(limitCollection.data());
//       listTransaction.add(limitModel);
//     }
//     for (var eachTransation in transationData.docs) {
//       var transactionModel = TransactionModel.fromMap(eachTransation.data());
//       // Only For income and Expense
//       if (transactionModel.income) {
//         totalIncome += int.parse(transactionModel.amount);
//       } else {
//         totalExpense += int.parse(transactionModel.amount);
//       }
//       // Format DateWise Transaction and TimeStamp
//       var date = DateTime.fromMillisecondsSinceEpoch(
//           int.parse(transactionModel.createAt));

//       if (DateTime.now().day == date.day) {
//         dateWiseTransaction['today']!.add(transactionModel);
//       } else if ((DateTime.now().day - 1).toString() == date.day.toString()) {
//         dateWiseTransaction['yesterday']!.add(transactionModel);
//       } else if ((DateTime.now().month).toString() == date.month.toString()) {
//         dateWiseTransaction['this month']!.add(transactionModel);
//       } else if ((DateTime.now().year).toString() == date.year.toString()) {
//         dateWiseTransaction['this year']!.add(transactionModel);
//       }

//       // Month-Wise Transactions
//       var month = date.month;
//       // if (monthWiseTransactions[month].transactions == null) {
//       //   monthWiseTransactions[month].transactions = [];
//       // }

//       print('not Found');
//       List<TransactionModel> listOfMonthWiseTransation = [];
//       for (int i = 1; i <= 12; i++) {
//         //
//         print(i);

//         print('found but not worked');
//         if (i == month) {
//           listOfMonthWiseTransation.add(transactionModel);

//           if (listOfMonthWiseTransation.isNotEmpty) {
//             monthWiseTransactions.add(MonthModel(
//                 id: i, title: '', transactions: listOfMonthWiseTransation));
//           }
//         }
//       }
//       var eachMonthIncome = 0;
//       var eachMonthExpense = 0;

//       for (var eachMonth in monthWiseTransactions) {
//         for (var eachTransation in eachMonth.transactions!) {
//           if (eachTransation.income) {
//             eachMonthIncome += int.parse(transactionModel.amount);
//           } else {
//             eachMonthExpense += int.parse(transactionModel.amount);
//           }
//         }
//       }
//       // Weekday-Wise Transactions
//       // var weekday = date.weekday;
//       // String weekdayStr = '';
//       // switch (weekday) {
//       //   case DateTime.monday:
//       //     weekdayStr = 'Monday';
//       //     break;
//       //   case DateTime.tuesday:
//       //     weekdayStr = 'Tuesday';
//       //     break;
//       //   case DateTime.wednesday:
//       //     weekdayStr = 'Wednesday';
//       //     break;
//       //   case DateTime.thursday:
//       //     weekdayStr = 'Thursday';
//       //     break;
//       //   case DateTime.friday:
//       //     weekdayStr = 'Friday';
//       //     break;
//       //   case DateTime.saturday:
//       //     weekdayStr = 'Saturday';
//       //     break;
//       //   case DateTime.sunday:
//       //     weekdayStr = 'Sunday';
//       //     break;
//       // }
//       // weekdayWiseTransactions[weekdayStr]!.add(transactionModel);

//       // Update category-wise income and expense
//       var category = transactionCategory.firstWhere(
//           (cat) => cat.id == transactionModel.categoryId,
//           orElse: () =>
//               CategoryModel(id: transactionModel.categoryId, title: 'Unknown'));
//       var existingCategoryIndex =
//           categoryModel.indexWhere((cat) => cat.id == category.id);

//       if (existingCategoryIndex >= 0) {
//         var existingCategory = categoryModel[existingCategoryIndex];
//         var updatedTransactions =
//             List<TransactionModel>.from(existingCategory.transactions ?? [])
//               ..add(transactionModel);

//         var updatedIncome = existingCategory.income;
//         var updatedExpense = existingCategory.expense;
//         if (transactionModel.income) {
//           updatedIncome += int.parse(transactionModel.amount);
//         } else {
//           updatedExpense += int.parse(transactionModel.amount);
//         }

//         categoryModel[existingCategoryIndex] = existingCategory.copyWith(
//           transactions: updatedTransactions,
//           income: updatedIncome,
//           expense: updatedExpense,
//         );
//       } else {
//         categoryModel.add(category.copyWith(
//           transactions: [transactionModel],
//           income:
//               transactionModel.income ? int.parse(transactionModel.amount) : 0,
//           expense:
//               transactionModel.income ? 0 : int.parse(transactionModel.amount),
//         ));
//       }
//     }
//     return ExpenseModel(
//       expense: totalExpense.toString(),
//       income: totalIncome.toString(),
//       id: userId,
//       dateWiseExpenses: dateWiseTransaction,
//       transactions: listTransaction,
//       categoryWiseExpense: categoryModel,
//       monthWiseTransactions: monthWiseTransactions,
//       weekdayWiseTransactions: monthWiseTransactions,
//     );
//   }

//   FutureOr<void> _fetchExpenseEvent(
//       FetchExpenseEvent event, Emitter<ExpenseState> emit) async {
//     emit(ExpenseLoadingState());
//     try {
//       var expenseModel = await fetchExpense();
//       if (expenseModel.transactions != null) {
//         emit(ExpenseSuccessState(expenseModel: expenseModel));
//       }
//     } on FirebaseAuthException catch (e) {
//       emit(ExpenseFailureState(errorMsg: e.message!));
//     } on SocketException catch (e) {
//       emit(ExpenseFailureState(errorMsg: e.message));
//     } catch (e) {
//       emit(ExpenseFailureState(errorMsg: e.toString()));
//     }
//   }

//   FutureOr<void> _addExpenseEvent(
//       AddExpenseEvent event, Emitter<ExpenseState> emit) async {
//     emit(ExpenseLoadingState());
//     try {
//       String userId = auth.currentUser!.uid;
//       var uuid = IdGenerator.transactionID();
//       print('THis Is UUID V4$uuid');
//       TransactionModel transaction = TransactionModel(
//           id: uuid,
//           title: event.transactionModel.title,
//           categoryId: event.transactionModel.categoryId,
//           createAt: event.transactionModel.createAt,
//           amount: event.transactionModel.amount,
//           income: event.transactionModel.income);
//       await firestore
//           .collection(FirebaseConst.userCollection)
//           .doc(userId)
//           .collection(FirebaseConst.transationCollection)
//           .doc(uuid)
//           .set(transaction.toMap())
//           .then((value) {
//         emit(ExpenseCrudSucccesState());
//       });

//       var expenseModel = await fetchExpense();

//       if (expenseModel.transactions != null) {
//         emit(ExpenseSuccessState(expenseModel: expenseModel));
//       }
//     } on FirebaseAuthException catch (e) {
//       emit(ExpenseFailureState(errorMsg: e.message!));
//     } on SocketException catch (e) {
//       emit(ExpenseFailureState(errorMsg: e.message));
//     } catch (e) {
//       emit(ExpenseFailureState(errorMsg: e.toString()));
//     }
//   }

//   FutureOr<void> _updateExpenseEvent(
//       UpdateExpenseEvent event, Emitter<ExpenseState> emit) async {
//     emit(ExpenseLoadingState());
//     try {
//       String userId = auth.currentUser!.uid;
//       await firestore
//           .collection(FirebaseConst.userCollection)
//           .doc(userId)
//           .collection(FirebaseConst.transationCollection)
//           .doc(event.transaction.id)
//           .update(event.transaction.toMap());
//       emit(ExpenseCrudSucccesState());

//       var expenseModel = await fetchExpense();

//       if (expenseModel.transactions != null) {
//         emit(ExpenseSuccessState(expenseModel: expenseModel));
//       }
//     } on FirebaseAuthException catch (e) {
//       emit(ExpenseFailureState(errorMsg: e.message!));
//     } on SocketException catch (e) {
//       emit(ExpenseFailureState(errorMsg: e.message));
//     } catch (e) {
//       emit(ExpenseFailureState(errorMsg: e.toString()));
//     }
//   }

//   FutureOr<void> _deleteExpenseEvent(
//       DeleteExpenseEvent event, Emitter<ExpenseState> emit) async {
//     try {
//       String userId = auth.currentUser!.uid;
//       await firestore
//           .collection(FirebaseConst.userCollection)
//           .doc(userId)
//           .collection(FirebaseConst.transationCollection)
//           .doc(event.transaction.id)
//           .delete();

//       var expenseModel = await fetchExpense();

//       if (expenseModel.transactions != null) {
//         emit(ExpenseSuccessState(expenseModel: expenseModel));
//       }
//     } on FirebaseAuthException catch (e) {
//       emit(ExpenseFailureState(errorMsg: e.message!));
//     } on SocketException catch (e) {
//       emit(ExpenseFailureState(errorMsg: e.message));
//     } catch (e) {
//       emit(ExpenseFailureState(errorMsg: e.toString()));
//     }
//   }
// }
