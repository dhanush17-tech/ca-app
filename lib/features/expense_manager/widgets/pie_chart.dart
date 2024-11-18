// ignore_for_file: must_be_immutable

import 'package:ca_appoinment/app/theme/color.dart';
import 'package:ca_appoinment/app/widgets/my_card_widget.dart';
import 'package:ca_appoinment/features/expense_manager/model/categories_model.dart';
import 'package:ca_appoinment/features/expense_manager/model/expense_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MyPieChart extends StatefulWidget {
  MyPieChart({super.key, required this.expModel});
  ExpenseModel? expModel;

  @override
  State<MyPieChart> createState() => _MyPieChartState();
}

class _MyPieChartState extends State<MyPieChart> {
  var dropdownContoller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MyCardWidget(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 7),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(12)),
              child: DropdownMenu(
                  inputDecorationTheme: InputDecorationTheme(
                      contentPadding: const EdgeInsets.all(5),
                      floatingLabelStyle: TextField.materialMisspelledTextStyle,
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(12))),
                  menuStyle: const MenuStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(AppPalates.white),
                      surfaceTintColor:
                          MaterialStatePropertyAll(AppPalates.white),
                      padding: MaterialStatePropertyAll(
                        EdgeInsets.all(10),
                      )),
                  controller: dropdownContoller,
                  initialSelection: 'Expense',
                  onSelected: (value) {
                    setState(() {
                      dropdownContoller.text = value!;
                    });
                  },
                  dropdownMenuEntries: const [
                    DropdownMenuEntry(value: 'Expense', label: 'Expense'),
                    DropdownMenuEntry(value: 'Income', label: 'Income'),
                  ]),
            ),
          ),
          const SizedBox(height: 10),
          MyFlPieChart(
              categories: widget.expModel!.categoryWiseExpense!,
              dropdownContoller: dropdownContoller,
              total: widget.expModel!),
        ],
      ),
    );
  }
}

class MyFlPieChart extends StatefulWidget {
  const MyFlPieChart({
    super.key,
    required this.categories,
    required this.dropdownContoller,
    required this.total,
  });

  final List<CategoryModel>? categories;
  final ExpenseModel? total;
  final TextEditingController dropdownContoller;

  @override
  State<MyFlPieChart> createState() => _MyFlPieChartState();
}

class _MyFlPieChartState extends State<MyFlPieChart> {
  @override
  Widget build(BuildContext context) {
    return MyCardWidget(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: AspectRatio(
                aspectRatio: 1.1,
                child: PieChart(PieChartData(
                  borderData: FlBorderData(
                    show: true,
                  ),
                  sectionsSpace: 2,
                  centerSpaceRadius: 45,
                  sections: widget.categories!.map((e) {
                    const shadows = [
                      Shadow(color: AppPalates.black, blurRadius: 2)
                    ];
        
                    var percentageExp =
                        '${((e.expense / int.parse(widget.total!.expense)) * 100).toStringAsFixed(0)}%';
                    var percentageInc =
                        '${((e.income / int.parse(widget.total!.income)) * 100).toStringAsFixed(0)}%';
                    if (widget.dropdownContoller.text == 'Expense' &&
                        e.expense != 0) {
                      return PieChartSectionData(
                        color: e.color,
                        value: double.parse(e.expense.toString()),
                        title: percentageExp,
                        borderSide: const BorderSide(color: AppPalates.black),
                        radius: 45,
                        titleStyle: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppPalates.white,
                          shadows: shadows,
                        ),
                      );
                    } else if (widget.dropdownContoller.text == 'Income' &&
                        e.income != 0) {
                      return PieChartSectionData(
                        color: e.color,
                        value: double.parse(e.income.toString()),
                        title: percentageInc,
                        radius: 45,
                        borderSide: const BorderSide(color: AppPalates.black),
                        titleStyle: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppPalates.white,
                            shadows: shadows),
                      );
                    } else {
                      return PieChartSectionData();
                    }
                  }).toList(),
                )),
              ),
            ),
            Expanded(
              flex: 1,
              child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(vertical: 0),
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.categories!.length,
                  itemBuilder: (context, index) {
                    var model = widget.categories![index];
                    return Center(
                      child: SizedBox(
                          height: 20,
                          width: 100,
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 8,
                                backgroundColor: model.color,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                model.title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                            ],
                          )),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
