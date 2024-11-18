// ignore_for_file: must_be_immutable

import 'package:ca_appoinment/app/routes/app_routes.dart';
import 'package:ca_appoinment/app/theme/color.dart';
import 'package:ca_appoinment/app/widgets/my_card_widget.dart';
import 'package:ca_appoinment/features/professional/profile/models/pro_account_model.dart';
import 'package:ca_appoinment/features/tax/widgets/tax_app_bar.dart';
import 'package:flutter/material.dart';

import '../../../app/widgets/ca_profile.dart';
import '../widgets/detaile_black_container.dart';

class TaxFillingDetailsScreen extends StatefulWidget {
  const TaxFillingDetailsScreen({super.key});

  @override
  State<TaxFillingDetailsScreen> createState() =>
      _TaxFillingDetailsScreenState();
}

class _TaxFillingDetailsScreenState extends State<TaxFillingDetailsScreen> {
  ProfessionalAccountModel? model;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var arg = ModalRoute.of(context)!.settings.arguments;
      if (arg is ProfessionalAccountModel) {
        setState(() {
          model = arg;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (model == null) {
      return Scaffold(
        appBar: myTaxAppBar('  '),
        body: const CircularProgressIndicator(
          color: AppPalates.black,
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CaProfile(model: model),
                  const SizedBox(height: 20),
                  SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: Row(
                        children: [
                          DetaileBlackContainer(
                              subtitle: 'Experience', title: '4+ year'),
                          const SizedBox(width: 10),
                          DetaileBlackContainer(
                              subtitle: 'Review', title: '3.5'),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MyCardWidget(
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Description',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppPalates.black,
                                  fontSize: 20),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                model!.description!,
                                textAlign: TextAlign.justify,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  model!.accountType == 'fa'
                      ? const SizedBox()
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MyCardWidget(
                            elevation: 0,
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Required Document',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppPalates.black,
                                        fontSize: 20),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: Text(
                                        '• Addhar card\n• Pan card\n• Bank statements\n• More as per requirements',
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: SizedBox(
                  width: MediaQuery.of(context).size.width - 25,
                  height: 50,
                  child: GestureDetector(
                      child: Container(
                          decoration: BoxDecoration(
                              color: AppPalates.primary,
                              borderRadius: BorderRadius.circular(10)),
                          child: const Center(
                            child: Padding(
                              padding: EdgeInsets.all(12),
                              child: Text(
                                'Book Appointment',
                                style: TextStyle(
                                    color: AppPalates.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 19),
                              ),
                            ),
                          )),
                      onTap: () {
                        Navigator.pushNamed(
                            context, AppRoutes.appointmentBookingScreen,
                            arguments: model);
                      })),
            ),
          ),
        ],
      ),
    );
  }
}
