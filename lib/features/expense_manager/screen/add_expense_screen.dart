import 'package:ca_appoinment/app/routes/app_routes.dart';
import 'package:ca_appoinment/app/theme/color.dart';
import 'package:ca_appoinment/app/widgets/my_elevated_button.dart';
import 'package:ca_appoinment/app/widgets/my_icon_pop_button.dart';
import 'package:ca_appoinment/features/expense_manager/arguments/add_expense_arg.dart';
import 'package:ca_appoinment/features/expense_manager/expense_bloc/expense_bloc.dart';
import 'package:ca_appoinment/features/expense_manager/model/categories_model.dart';
import 'package:ca_appoinment/features/expense_manager/model/transaction_model.dart';
import 'package:ca_appoinment/features/expense_manager/provider/expense_provider.dart';
import 'package:ca_appoinment/features/expense_manager/widgets/choice_chip.dart';
import 'package:ca_appoinment/features/expense_manager/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddexpenseScreen extends StatefulWidget {
  const AddexpenseScreen({super.key});

  @override
  State<AddexpenseScreen> createState() => _AddexpenseScreenState();
}

class _AddexpenseScreenState extends State<AddexpenseScreen> {
  AddExpenseArgument? arg;
  var amountController = TextEditingController();
  var noteController = TextEditingController();
  late DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var routesArg = ModalRoute.of(context)!.settings.arguments;
      setState(() {
        if (routesArg is AddExpenseArgument) {
          arg = routesArg;
        }
        if (arg!.isUpdate) {
          var providerM = context.read<ExpenseProvider>();
          amountController.text = arg!.transactionModel!.amount;
          noteController.text = arg!.transactionModel!.title;
          providerM.expenseType =
              arg!.transactionModel!.income == true ? 'income' : 'expense';
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (arg == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: AppPalates.primary,
          ),
        ),
      );
    }
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: const Padding(
            padding: EdgeInsets.all(3),
            child: MyIconPopButton(),
          ),
          title: Text(
            !arg!.isUpdate ? 'Add Transaction' : 'Update Transaction',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Consumer<ExpenseProvider>(builder: (context, provider, child) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  ExpenseTextField(
                    suffixIcon: Icons.calendar_month,
                    hintText: 'Add a note',
                    controller: noteController,
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 50,
                    child: Row(
                      children: [
                        Expanded(
                          child: ExpenseTextField(
                            suffixIcon: Icons.notes,
                            keyboardType: TextInputType.number,
                            hintText: 'Amount',
                            controller: amountController,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: SizedBox(
                            height: double.infinity,
                            child: ElevatedButton(
                                onPressed: () async {
                                  selectedDate = await showDatePicker(
                                      context: context,
                                      initialDate: arg!.isUpdate
                                          ? DateTime.fromMillisecondsSinceEpoch(
                                              int.parse(arg!
                                                  .transactionModel!.createAt))
                                          : DateTime.now(),
                                      firstDate:
                                          DateTime(DateTime.now().year - 5),
                                      lastDate: DateTime.now());
                                  if (selectedDate != null) {
                                    provider.selectedDate = selectedDate;
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    backgroundColor: AppPalates.primary,
                                    foregroundColor: AppPalates.white),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    provider.selectedDate != null
                                        ? FittedBox(
                                            child: Text(
                                              DateFormat.yMMMd().format(
                                                  provider.selectedDate!),
                                              style: const TextStyle(
                                                  overflow: TextOverflow.fade),
                                            ),
                                          )
                                        : const Text('Select Date'),
                                    const Icon(Icons.date_range_rounded)
                                  ],
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    children: [
                      ExpenseTypeChoiceChip(
                        labels: const ['Income', 'Expense'],
                        selectedLabel: provider.expenseType.toLowerCase(),
                        onSelected: (String selected) {
                          if (arg!.isUpdate) {
                            provider.expenseType =
                                arg!.transactionModel!.income == true
                                    ? 'income'
                                    : 'expense';
                          }
                          provider.expenseType = selected.toLowerCase();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Selcted Category',
                    style: TextStyle(
                        color: AppPalates.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 20),
                  ),
                  Wrap(
                    spacing: 5,
                    runSpacing: 5,
                    children: transactionCategory.map((e) {
                     
                      late bool selected;
                      if (arg!.isUpdate) {
                        selected = arg!.transactionModel!.categoryId == e.id;
                      } else {
                        selected = provider.categoryid == e.id;
                      }
                      return ChoiceChip(
                        label: Text(e.title),
                        selected: selected,
                        onSelected: (selected) {
                          provider.categoryName = e.title;
                          provider.categoryid = e.id;
                          if (arg!.isUpdate) {
                            arg!.transactionModel!.categoryId = e.id;
                          }
                        },
                        selectedColor: AppPalates.primary,
                        checkmarkColor: AppPalates.white,
                        labelStyle: TextStyle(
                          color: selected ? Colors.white : Colors.black,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                      width: double.infinity,
                      child: BlocConsumer<ExpenseBloc, ExpenseState>(
                        listener: (context, state) {
                          if (state is ExpenseCrudSucccesState) {
                            Navigator.pushReplacementNamed(
                                context, AppRoutes.home);
                          }
                        },
                        builder: (context, state) {
                          if (state is ExpenseLoadingState) {
                            return MyElevatedButton(
                              btName: arg!.isUpdate ? 'Update' : 'Save',
                              onTap: () {},
                              widget: const CircularProgressIndicator(
                                color: AppPalates.white,
                              ),
                            );
                          }
                          if (state is ExpenseFailureState) {
                            return Text(
                              state.errorMsg,
                              style: const TextStyle(color: AppPalates.red),
                            );
                          }
                          return MyElevatedButton(
                              btName: arg!.isUpdate ? 'Update' : 'Save',
                              onTap: () {
                                var notes = noteController.text;
                                var amount = amountController.text;
                                if (notes.isNotEmpty && amount.isNotEmpty) {
                                  var transactionModel = TransactionModel(
                                      id: '',
                                      title: notes,
                                      categoryId: provider.categoryid,
                                      createAt: provider
                                          .selectedDate!.millisecondsSinceEpoch
                                          .toString(),
                                      amount: amount,
                                      income: provider.expenseType == 'income'
                                          ? true
                                          : false);
                                  if (arg!.isUpdate) {
                                    var transactionModel = TransactionModel(
                                        id: arg!.transactionModel!.id,
                                        title: notes,
                                        categoryId: provider.categoryid,
                                        createAt: provider.selectedDate!
                                            .millisecondsSinceEpoch
                                            .toString(),
                                        amount: amount,
                                        income: provider.expenseType == 'income'
                                            ? true
                                            : false);
                                    context.read<ExpenseBloc>().add(
                                        UpdateExpenseEvent(
                                            transaction: transactionModel));
                                  } else {
                                    context.read<ExpenseBloc>().add(
                                        AddExpenseEvent(
                                            transactionModel:
                                                transactionModel));
                                  }
                                }
                              });
                        },
                      ))
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
