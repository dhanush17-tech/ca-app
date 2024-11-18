// ignore_for_file: must_be_immutable

import 'package:ca_appoinment/app/routes/app_routes.dart';
import 'package:ca_appoinment/app/theme/color.dart';
import 'package:ca_appoinment/app/widgets/my_card_widget.dart';
import 'package:ca_appoinment/app/widgets/my_elevated_button.dart';
import 'package:ca_appoinment/features/expense_manager/arguments/add_expense_arg.dart';
import 'package:ca_appoinment/features/expense_manager/expense_bloc/expense_bloc.dart';
import 'package:ca_appoinment/features/expense_manager/model/categories_model.dart';
import 'package:ca_appoinment/features/expense_manager/model/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  TransactionList({
    super.key,
    this.title,
    required this.transactions,
  });
  List<TransactionModel>? transactions;
  String? title;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title != null
            ? Padding(
                padding: const EdgeInsets.all(4),
                child: Text(
                  title!.replaceFirst(title![0], title![0].toUpperCase()),
                  style: const TextStyle(
                      color: AppPalates.black,
                      fontSize: 19,
                      fontWeight: FontWeight.bold),
                ), 
              )
            : const SizedBox(),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: transactions!.length,
          itemBuilder: (context, index) {
            var model = transactions![index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: MyCardWidget(
                child: GestureDetector(
                  onLongPress: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Center(
                          child: Container(
                            width: 300,
                            height: 120,
                            decoration: BoxDecoration(
                                color: AppPalates.white,
                                borderRadius: BorderRadius.circular(15)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    MyElevatedButton(
                                        btName: 'Update',
                                        onTap: () {
                                          Navigator.pop(context);
                                          Navigator.pushNamed(
                                              context, AppRoutes.addExpense,
                                              arguments: AddExpenseArgument(
                                                  transactionModel: model,
                                                  isUpdate: true));
                                        }),
                                    const SizedBox(width: 20),
                                    MyElevatedButton(
                                        btName: 'Delete',
                                        onTap: () {
                                          context.read<ExpenseBloc>().add(
                                              DeleteExpenseEvent(
                                                  transaction: model));
                                          Navigator.pop(context);
                                          context
                                              .read<ExpenseBloc>()
                                              .add(FetchExpenseEvent());
                                        }),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    leading: CircleAvatar(
                      backgroundColor: transactionCategory[model.categoryId]
                          .color!
                          .withOpacity(0.7),
                      child: Icon(transactionCategory[model.categoryId].icons,
                          color: AppPalates.white),
                    ),
                    title: Text(transactionCategory[model.categoryId].title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppPalates.black)),
                    subtitle: Text(
                      model.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: AppPalates.black26),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          model.income == true
                              ? '+${model.amount}'
                              : '-${model.amount}',
                          style: TextStyle(
                              fontSize: 16,
                              color: model.income == true
                                  ? AppPalates.green
                                  : AppPalates.red),
                        ),
                        Text(
                          title == 'today' || title == 'yesterday'
                              ? DateFormat('hh:mm a').format(
                                  DateTime.fromMillisecondsSinceEpoch(
                                      int.parse(model.createAt)))
                              : DateFormat.yMMMd().format(
                                  DateTime.fromMillisecondsSinceEpoch(
                                      int.parse(model.createAt))),
                          style: const TextStyle(color: AppPalates.black),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 20)
      ],
    );
  }
}
