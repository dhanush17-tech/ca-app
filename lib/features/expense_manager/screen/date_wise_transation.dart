// ignore_for_file: camel_case_types

import 'package:ca_appoinment/app/theme/color.dart';
import 'package:ca_appoinment/app/widgets/my_icon_pop_button.dart';
import 'package:ca_appoinment/features/expense_manager/model/expense_model.dart';
import 'package:ca_appoinment/features/expense_manager/widgets/transaction_list.dart';
import 'package:flutter/material.dart';

import '../widgets/build_bar_chart.dart';

class SeeAllTransation extends StatefulWidget {
  const SeeAllTransation({super.key});

  @override
  State<SeeAllTransation> createState() => _SeeAllTransationState();
}

class _SeeAllTransationState extends State<SeeAllTransation> {
  ExpenseModel? model;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var arg = ModalRoute.of(context)!.settings.arguments as ExpenseModel;
      setState(() {
        model = arg;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (model == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(3),
          child: MyIconPopButton(),
        ),
        title: const Text(
          'All Transaction',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: buildBarChart(model!.monthWiseTransactions!)),
            const SizedBox(height: 10),
            const Indicator(),
            const SizedBox(height: 10),
            for (var eachDate in model!.dateWiseExpenses.entries)
              if (eachDate.value.isNotEmpty)
                TransactionList(
                  transactions: eachDate.value,
                  title: eachDate.key,
                ),
          ],
        ),
      ),
    );
  }
}

class Indicator extends StatelessWidget {
  const Indicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 10,
              width: 10,
              decoration: BoxDecoration(
                  color: AppPalates.red,
                  borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(width: 5),
            const Text(
              'Expense',
              style: TextStyle(fontWeight: FontWeight.bold),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 10,
              width: 10,
              decoration: BoxDecoration(
                  color: AppPalates.black,
                  borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(width: 5),
            const Text(
              'Income',
              style: TextStyle(fontWeight: FontWeight.bold),
            )
          ],
        ),
      ],
    );
  }
}
