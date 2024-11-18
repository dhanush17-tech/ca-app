// ignore_for_file: camel_case_types

import 'package:ca_appoinment/app/theme/color.dart';
import 'package:ca_appoinment/features/expense_manager/model/month_wise_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

Widget buildBarChart(List<MonthModel> monthData) {
  double calculateMaxY() {
    double maxY = 0;
    for (var monthModel in monthData) {
      if (monthModel.totalExpense.toDouble() > maxY) {
        maxY = monthModel.totalExpense.toDouble();
      }
      if (monthModel.totalIncome.toDouble() > maxY) {
        maxY = monthModel.totalIncome.toDouble();
      }
    }
    return (maxY * 1.2).round().ceilToDouble(); // Adding 10% padding
  }

  double maxY = calculateMaxY();
  return SingleChildScrollView(
    child: AspectRatio(
      aspectRatio: 16 / 12,
      child: BarChart(
        BarChartData(
          maxY: maxY,
          alignment: BarChartAlignment.spaceAround,
          barTouchData: BarTouchData(
            enabled: true,
          ),
          groupsSpace: 40,
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (double value, meta) {
                      if (value.toInt() >= 0 &&
                          value.toInt() < monthData.length) {
                        return Text(
                          monthData[value.toInt()].title.substring(0, 3),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        );
                      }
                      return const Text('Null');
                    })),
            leftTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(
            show: false,
          ),
          barGroups: List.generate(
            monthData.length,
            (index) => BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: monthData[index].totalExpense.toDouble(),
                  color: AppPalates.red,
                  backDrawRodData: BackgroundBarChartRodData(
                      show: true, toY: 1, color: AppPalates.red),
                  width: 20,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(4)),
                ),
                BarChartRodData(
                  toY: monthData[index].totalIncome.toDouble(),
                  color: Colors.black,
                  width: 20,
                  backDrawRodData: BackgroundBarChartRodData(
                      show: true, toY: 1, color: AppPalates.black),
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(4)),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
