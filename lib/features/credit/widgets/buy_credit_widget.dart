import 'package:ca_appoinment/app/theme/color.dart';
import 'package:ca_appoinment/app/widgets/my_elevated_button.dart';
import 'package:ca_appoinment/features/credit/blocs/credit_bloc/credit_bloc.dart';
import 'package:ca_appoinment/features/user/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BuyCreditWidget extends StatelessWidget {
  const BuyCreditWidget({
    super.key,
    required this.userModel,
  });

  final UserModel? userModel;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: const Text(
        'Buy Credits',
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppPalates.black),
      ),
      childrenPadding: const EdgeInsets.all(10),
      children: [
        MyCreditTile(
            amount: '200',
            credits: '2',
            validity: 6,
            onTap: () async {
              context.read<CreditBloc>().add(CreditBuyEvent(
                  credit: 2,
                  amount: 200));
            }),
        MyCreditTile(
            amount: '400',
            credits: '6',
            validity: 6,
            onTap: () {
              context.read<CreditBloc>().add(CreditBuyEvent(
                  credit: 6,
                  amount: 400));
            }),
        MyCreditTile(
            amount: '600',
            credits: '10',
            validity: 6,
            onTap: () {
              context.read<CreditBloc>().add(CreditBuyEvent(
                  credit: 10,
                  amount: 600));
            }),
      ],
    );
  }
}

class MyCreditTile extends StatelessWidget {
  MyCreditTile({
    super.key,
    required this.amount,
    required this.credits,
    required this.onTap,
    required this.validity,
  });
  String credits;
  String amount;
  VoidCallback onTap;
  int validity;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('$credits Credits',
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: AppPalates.black)),
      subtitle: Text('$amount Rs only, validity $validity Months',
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: AppPalates.textGrey)),
      trailing: MyElevatedButton(
        btName: 'Buy',
        onTap: onTap,
      ),
    );
  }
}