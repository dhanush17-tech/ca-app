// ignore_for_file: must_be_immutable

import 'package:ca_appoinment/app/routes/app_routes.dart';
import 'package:ca_appoinment/app/theme/color.dart';
import 'package:ca_appoinment/app/widgets/my_outline_button.dart';
import 'package:ca_appoinment/features/expense_manager/arguments/add_expense_arg.dart';
import 'package:ca_appoinment/features/expense_manager/expense_bloc/expense_bloc.dart';
import 'package:ca_appoinment/features/expense_manager/widgets/pie_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import '../../../app/common/meeting/meeting_listener_widget.dart';
import '../widgets/expanse_view_container.dart';
import '../widgets/transaction_list.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({super.key});

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ExpenseBloc>().add(FetchExpenseEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.addExpense,
              arguments: AddExpenseArgument());
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        backgroundColor: AppPalates.primary,
        child: const Icon(
          CupertinoIcons.add,
          size: 30,
          weight: 5,
          color: AppPalates.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const MeetingListenerWidget(),
            Padding(
              padding: const EdgeInsets.all(5),
              child: BlocBuilder<ExpenseBloc, ExpenseState>(
                builder: (context, state) {
                  if (state is ExpenseLoadingState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 100,
                          decoration: BoxDecoration(
                              color: AppPalates.greyShade100,
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 80,
                                decoration: BoxDecoration(
                                  color: AppPalates.greyShade100,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Container(
                                height: 80,
                                decoration: BoxDecoration(
                                  color: AppPalates.greyShade100,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: 150,
                          height: 35,
                          decoration: BoxDecoration(
                              color: AppPalates.greyShade100,
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        const SizedBox(height: 5),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Container(
                                width: double.infinity,
                                height: 70,
                                decoration: BoxDecoration(
                                    color: AppPalates.greyShade100,
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  }
                  if (state is ExpenseFailureState) {
                    return Center(
                        child: Text(state.errorMsg.characters.toString()));
                  }
                  if (state is ExpenseSuccessState) {
                    if (state.expenseModel!.transactions!.isEmpty ||
                        state.expenseModel!.categoryWiseExpense == null) {
                      return Column(
                        children: [
                          ExpanseViewContainer(
                            expeModel: state.expenseModel!,
                          ),
                          const SizedBox(height: 15),
                          Center(
                            child: Lottie.asset(
                                'assets/lottie/no_transcation.json',
                                repeat: false),
                          ),
                        ],
                      );
                    }

                    return Column(
                      children: [
                        //Expense totals
                        ExpanseViewContainer(
                          expeModel: state.expenseModel!,
                        ),

                        const SizedBox(height: 20),
                        //Pie Chart
                        MyPieChart(
                          expModel: state.expenseModel!,
                        ),
                        //Transations List
                        const SizedBox(height: 15),
                        // for (var eachDate
                        //     in state.expenseModel!.dateWiseExpenses.entries)
                        //   if (eachDate.value.isNotEmpty)
                        //     TransactionList(
                        //       transactions: eachDate.value,
                        //       title: eachDate.key,
                        //     ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(4),
                              child: Text(
                                'Recents',
                                style: TextStyle(
                                    color: AppPalates.black,
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            MyOutlineButton(
                                btName: 'View All',
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, AppRoutes.seeAllTransation,
                                      arguments: state.expenseModel);
                                })
                          ],
                        ),
                        TransactionList(
                          title: null,
                          transactions: state.expenseModel!.transactions!,
                        ),
                        const SizedBox(height: 80),
                      ],
                    );
                  }

                  {
                    return const SizedBox();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
