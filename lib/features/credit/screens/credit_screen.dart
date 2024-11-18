import 'package:ca_appoinment/app/routes/app_routes.dart';
import 'package:ca_appoinment/app/theme/color.dart';
import 'package:ca_appoinment/app/widgets/my_card_widget.dart';
import 'package:ca_appoinment/app/widgets/my_icon_pop_button.dart';
import 'package:ca_appoinment/features/credit/blocs/credit_bloc/credit_bloc.dart';
import 'package:ca_appoinment/features/user/blocs/user_bloc/user_bloc.dart';
import 'package:ca_appoinment/features/user/model/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../widgets/buy_credit_widget.dart';

class CreditScreen extends StatefulWidget {
  const CreditScreen({super.key});

  @override
  State<CreditScreen> createState() => _CreditScreenState();
}

class _CreditScreenState extends State<CreditScreen> {
  UserModel? userModel;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        context.read<UserBloc>().add(FetchProfileEvent());
        context.read<CreditBloc>().add(CreditFetchEvent());

        var arg = ModalRoute.of(context)!.settings.arguments;
        if (arg is UserModel) {
          setState(() {
            userModel = arg;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (userModel == null) {
      return const Scaffold(body: CircularProgressIndicator());
    }

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: const Padding(
            padding: EdgeInsets.all(3),
            child: MyIconPopButton(),
          ),
          actions: [
            MyIconButton(
              icon: CupertinoIcons.refresh,
              onTap: () {
                context.read<CreditBloc>().add(CreditFetchEvent());
              },
            )
          ],
          title: const Text(
            'Meeting Credits',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ),
        body: BlocBuilder<CreditBloc, CreditState>(
          builder: (context, state) {
            if (state is CreditSuccesState) {
              return SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Container(
                            height: 120,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: AppPalates.primary,
                                borderRadius: BorderRadius.circular(12)),
                            child: Center(
                                child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      width: 2, color: AppPalates.white)),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${state.model.balance}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22,
                                        color: AppPalates.white),
                                  ),
                                  const SizedBox(width: 5),
                                  const Icon(
                                    Icons.monetization_on,
                                    color: AppPalates.metalicGold,
                                    size: 28,
                                  ),
                                ],
                              ),
                            ))),
                      ),
                      BuyCreditWidget(userModel: userModel),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Recents',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: AppPalates.black),
                        ),
                      ),
                      ListView.builder(
                        itemCount: state.model.history!.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          var model = state.model.history![index];
                          return MyCardWidget(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, AppRoutes.orderDetails, arguments: model);
                                },
                                child: ListTile(
                                  trailing: CircleAvatar(
                                    backgroundColor: model.increase == true
                                        ? AppPalates.black
                                        : AppPalates.red,
                                    child: Text(
                                      model.increase == true
                                          ? '${model.credit}+'
                                          : '${model.credit}-',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: AppPalates.white),
                                    ),
                                  ),
                                  title: Text(
                                    model.increase
                                        ? model.orderId.toString()
                                        : 'Meeting Booked, Service Id: ${model.orderId}',
                                    style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  leading: Text(
                                    model.increase
                                        ? '${model.amount} Rs'
                                        : '- ${model.credit} Credit',
                                    style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    DateFormat('hh:mm:aa, d MMM,yyyy').format(
                                        DateTime.fromMillisecondsSinceEpoch(
                                            model.purchaseTime)),
                                    style: const TextStyle(
                                        color: AppPalates.textGrey,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    ]),
              );
            }

            if (state is CreditLoadingState) {
              return const Center(
                  child: CircularProgressIndicator(
                color: AppPalates.black,
              ));
            }
            if (state is CreditFailureState) {
              return Center(child: Text(state.errorMsg));
            }
            return const SizedBox();
          },
        ));
  }
}
