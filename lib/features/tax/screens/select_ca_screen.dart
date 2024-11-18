// ignore_for_file: must_be_immutable

import 'package:ca_appoinment/app/theme/color.dart';
import 'package:ca_appoinment/features/tax/bloc/ca_account_bloc/ca_account_bloc.dart';
import 'package:ca_appoinment/features/tax/widgets/professional_account_succes_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/profeessional_account_loading_state.dart';

class TaxFillingScreen extends StatefulWidget {
  const TaxFillingScreen({super.key});
  @override
  State<TaxFillingScreen> createState() => _TaxFillingScreenState();
}

class _TaxFillingScreenState extends State<TaxFillingScreen> {
  late String accountType;
  @override
  void initState() {
    super.initState();
    context.read<CaAccountsBloc>().add(CaAccountsFetchEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalates.white,
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 10),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Select CA',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(10),
            child: BlocBuilder<CaAccountsBloc, CaAccountState>(
              builder: (context, state) {
                if (state is CaAccountsLoadingState) {
                  return const ProfeessionalAccountLoaderState();
                }
                if (state is CaAccountsFailuerState) {
                  return ProfessionalAccountErrorState(
                    errorMsg: state.errorMsg,
                  );
                }
                if (state is CaAccountsSuccesState) {
                  if (state.accounts.isEmpty) {
                    return const Center(
                      child: Text(
                        'No Accountant Found',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    );
                  }
                  return ProfessionalAccountLoadedState(
                    accounts: state.accounts,
                  );
                }
                return const SizedBox();
              },
            ),
          )),
        ],
      ),
    );
  }
}

class ProfessionalAccountErrorState extends StatelessWidget {
  ProfessionalAccountErrorState({super.key, required this.errorMsg});
  String errorMsg;
  @override
  Widget build(BuildContext context) {
    return Center(child: Text(errorMsg));
  }
}
