import 'package:ca_appoinment/app/theme/color.dart';
import 'package:ca_appoinment/features/fa/bloc/fa_account_bloc.dart';
import 'package:ca_appoinment/features/tax/screens/select_ca_screen.dart';
import 'package:ca_appoinment/features/tax/widgets/profeessional_account_loading_state.dart';
import 'package:ca_appoinment/features/tax/widgets/professional_account_succes_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FaScreen extends StatefulWidget {
  const FaScreen({super.key});

  @override
  State<FaScreen> createState() => _FaScreenState();
}

class _FaScreenState extends State<FaScreen> {
  @override
  void initState() {
    super.initState();
    context.read<FaAccountBloc>().add(FaAccountFetchEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalates.white,

      // actions: [
      // IconButton(
      //     onPressed: () {
      //       context.read<FaAccountBloc>().add(FaAccountFetchEvent());
      //     },
      //     icon: const Icon(
      //       Icons.chat_outlined,
      //       color: AppPalates.black,
      //     )),
      // const SizedBox(width: 10),

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
                'Select Financial Manager',
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
              child: BlocBuilder<FaAccountBloc, FaAccountState>(
                builder: (context, state) {
                  if (state is FaAccountLoadingState) {
                    return const ProfeessionalAccountLoaderState();
                  }
                  if (state is FaAccountFailuerState) {
                    return ProfessionalAccountErrorState(
                        errorMsg: state.errorMsg);
                  }
                  if (state is FaAccountSuccesState) {
                    if (state.accounts.isEmpty) {
                      return const Center(
                        child: Text('No Financial Manger Found',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      );
                    }
                    return ProfessionalAccountLoadedState(
                        accounts: state.accounts);
                  }
                  return Container();
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
