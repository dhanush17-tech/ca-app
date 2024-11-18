// ignore_for_file: must_be_immutable

import 'package:ca_appoinment/app/theme/color.dart';
import 'package:ca_appoinment/app/widgets/my_card_widget.dart';
import 'package:ca_appoinment/features/expense_manager/model/expense_model.dart';
import 'package:flutter/material.dart';

class ExpanseViewContainer extends StatelessWidget {
  ExpanseViewContainer({super.key, required this.expeModel});
  ExpenseModel? expeModel;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MyCardWidget(
          child: Container(
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
                color: AppPalates.primary,
                borderRadius: BorderRadius.circular(10)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Available Balance',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppPalates.white,
                      fontSize: 16),
                ),
                const SizedBox(height: 7),
                Text(
                  '\$${(int.parse(expeModel!.income) - int.parse(expeModel!.expense))}',
                  style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      color: AppPalates.white,
                      fontSize: 25),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            Expanded(
              child: MyCardWidget(
                child: Container(
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppPalates.greenShade,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Income",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: AppPalates.black,
                        ),
                      ),
                      Text(
                        "\$${expeModel!.income}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 20,
                          color: AppPalates.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: MyCardWidget(
                child: Container(
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppPalates.redShade,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Expense",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: AppPalates.black,
                        ),
                      ),
                      Text(
                        "\$${expeModel!.expense}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 20,
                          color: AppPalates.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}
