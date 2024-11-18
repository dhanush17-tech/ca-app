// ignore_for_file: must_be_immutable

import 'package:ca_appoinment/features/bookings/model/booking_time_model.dart';
import 'package:ca_appoinment/app/theme/color.dart';
import 'package:ca_appoinment/app/widgets/my_drop_down.dart';
import 'package:ca_appoinment/app/widgets/my_icon_pop_button.dart';
import 'package:flutter/material.dart';

import '../../../app/widgets/my_doc_view_container.dart';

class UploadedDocuments extends StatefulWidget {
  const UploadedDocuments({super.key});

  @override
  State<UploadedDocuments> createState() => _UploadedDocumentsState();
}

class _UploadedDocumentsState extends State<UploadedDocuments> {
  BookingTimeModel? arg;
  var docTypeController = TextEditingController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var argModel =
          ModalRoute.of(context)!.settings.arguments as BookingTimeModel;
      setState(() {
        arg = argModel;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (arg == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: const Padding(
          padding: EdgeInsets.all(3.0),
          child: MyIconPopButton(),
        ),
        title: const Text(
          'Uploaded Documents',
          style:
              TextStyle(fontWeight: FontWeight.w600, color: AppPalates.black),
        ),
      ),
      body: Center(
        child: Column(
            children: [
              MyDropDownWidget(
                  selected: (value) {
                    setState(() {
                      docTypeController.text = value!;
                    });
                  },
                  myDropDown: const ['User Documents', 'Ca Documents'],
                  textEditingController: docTypeController),
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Builder(builder: (context) {
                    if (docTypeController.text == 'User Documents') {
                      if (arg!.userDocs != null) {
                        return SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              MyDocViewContainer(
                                  docModel: arg!.userDocs!.aadhaarCard!),
                              MyDocViewContainer(
                                  docModel: arg!.userDocs!.panCard!),
                              MyDocViewContainer(
                                  docModel: arg!.userDocs!.bankStatement!),
                            ],
                          ),
                        );
                      } else {
                        return const Center(
                          child: Text(
                            'User Not Uploaded Documents',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        );
                      }
                    } else {
                      if (arg!.caDocs != null) {
                        return MyDocViewContainer(docModel: arg!.caDocs!);
                      } else {
                        return const Center(
                          child: Text(
                            'Accountant Not Update Documents',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        );
                      }
                    }
                  }),
                ),
              ),
            ]),
      ),
    );
  }
}
