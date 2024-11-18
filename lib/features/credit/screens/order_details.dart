import 'package:ca_appoinment/app/theme/color.dart';
import 'package:ca_appoinment/app/widgets/my_divider.dart';
import 'package:ca_appoinment/features/credit/model/credit_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class OrderDetails extends StatefulWidget {
  const OrderDetails({super.key});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  CreditModel? creditModel;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        var arg = ModalRoute.of(context)!.settings.arguments;
        if (arg is CreditModel) {
          setState(() {
            creditModel = arg;
          });
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (creditModel == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Order Details',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Card(
              color: AppPalates.white,
              elevation: 5,
              surfaceTintColor: AppPalates.white,
              child: Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(12)),
                child: Center(
                    child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 25,
                        backgroundColor: AppPalates.greenShade,
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: CircleAvatar(
                              backgroundColor: AppPalates.green,
                              child: Icon(
                                Icons.done,
                                color: AppPalates.white,
                              )),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Payment Succes!',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: AppPalates.black),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Rs ${creditModel!.amount}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppPalates.black),
                      ),
                    ],
                  ),
                )),
              ),
            ),
            const SizedBox(height: 10),
            Card(
              color: AppPalates.white,
              elevation: 5,
              child: ExpansionTile(
                collapsedBackgroundColor: AppPalates.white,
                backgroundColor: AppPalates.white,
                childrenPadding: const EdgeInsets.all(10),
                collapsedShape: RoundedRectangleBorder(
                    side: BorderSide.none,
                    borderRadius: BorderRadius.circular(12)),
                shape: RoundedRectangleBorder(
                    side: BorderSide.none,
                    borderRadius: BorderRadius.circular(12)),
                title: const Text(
                  'Payment Details',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                children: [
                  PaymentDetailsTile(
                    title: 'Order Id',
                    value: creditModel!.orderId,
                  ),
                  const PaymentDetailsTile(
                    title: 'Status',
                    value: 'Succes',
                  ),
                  PaymentDetailsTile(
                    title: 'Credits',
                    value: creditModel!.credit.toString(),
                  ),
                  PaymentDetailsTile(
                    title: 'Time',
                    value: DateFormat('hh:mm:aa').format(
                        DateTime.fromMillisecondsSinceEpoch(
                            creditModel!.purchaseTime)),
                  ),
                  PaymentDetailsTile(
                    title: 'Date',
                    value: DateFormat.yMMMEd().format(
                        DateTime.fromMillisecondsSinceEpoch(
                            creditModel!.purchaseTime)),
                  ),
                  const MyDivider(),
                  PaymentDetailsTile(
                    title: 'Total Payment',
                    value: 'Rs ${creditModel!.amount}',
                  ),
                ],
              ),
            ),
            const Card(
                color: AppPalates.white,
                elevation: 5,
                child: ListTile(
                  leading: Icon(Icons.info_outline),
                  title: Text(
                    'Trouble With Your Payment?',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('Let Us Know on help center Now',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: AppPalates.textGrey)),
                  trailing: CircleAvatar(
                      backgroundColor: AppPalates.grey,
                      radius: 20,
                      child: Icon(
                        CupertinoIcons.right_chevron,
                        size: 22,
                        color: AppPalates.black,
                      )),
                ))
          ],
        ),
      ),
    );
  }
}

class PaymentDetailsTile extends StatelessWidget {
  const PaymentDetailsTile({
    super.key,
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          title,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 13),
        )
      ]),
    );
  }
}
