// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:ca_appoinment/app/theme/color.dart';
import 'package:ca_appoinment/features/expense_manager/model/transaction_model.dart';

class CategoryModel {
  int id;
  String title;
  IconData? icons;
  int income;
  int expense;
  Color? color;
  List<TransactionModel>? transactions;
  CategoryModel({
    required this.id,
    required this.title,
     this.icons,
     this.color,
    this.transactions,
    this.expense = 0,
    this.income = 0,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'icons': icons!.codePoint,
      'income': income,
      'expense': expense,
      'color': color!.value,
      'transactions': transactions!.map((x) => x.toMap()).toList(),
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] as int,
      title: map['title'] as String,
      icons: IconData(map['icons'] as int, fontFamily: 'MaterialIcons'),
      income: map['income'] as int,
      expense: map['expense'] as int,
      color: Color(map['color'] as int),
      transactions: map['transactions'] != null
          ? List<TransactionModel>.from(
              (map['transactions'] as List<int>).map<TransactionModel?>(
                (x) => TransactionModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }

  CategoryModel copyWith({
    int? id,
    String? title,
    IconData? icons,
    int? income,
    int? expense,
    List<TransactionModel>? transactions,
    Color? color,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      title: title ?? this.title,
      icons: icons ?? this.icons,
      expense: expense ?? this.expense,
      income: income ?? this.income,
      transactions: transactions ?? this.transactions,
      color: color ?? this.color,
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryModel.fromJson(String source) =>
      CategoryModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

List<CategoryModel> transactionCategory = [
  CategoryModel(
      id: 0,
      title: 'Food',
      icons: Icons.fastfood_outlined,
      color: AppPalates.red),
  CategoryModel(
      id: 1,
      title: 'Family',
      icons: Icons.family_restroom_rounded,
      color: AppPalates.yellow),
  CategoryModel(
      id: 2,
      title: 'Travel',
      icons: Icons.travel_explore_outlined,
      color: AppPalates.black),
  CategoryModel(
      id: 3,
      title: 'Health',
      icons: Icons.health_and_safety_outlined,
      color: AppPalates.purpal),
  CategoryModel(
      id: 4,
      title: 'Fuel',
      icons: Icons.local_gas_station_outlined,
      color: AppPalates.teal),
  CategoryModel(
      id: 5,
      title: 'Salary',
      icons: Icons.work_outline_rounded,
      color: AppPalates.blue),
  CategoryModel(
      id: 6,
      title: 'others',
      icons: Icons.devices_other_rounded,
      color: AppPalates.green),
];
