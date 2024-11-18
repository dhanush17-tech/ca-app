// ignore_for_file: must_be_immutable

import 'package:ca_appoinment/app/widgets/my_card_widget.dart';
import 'package:ca_appoinment/features/professional/profile/models/document_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyDocViewContainer extends StatelessWidget {
  MyDocViewContainer({
    super.key,
    required this.docModel,
  });
  DocumentModel docModel;
  @override
  Widget build(BuildContext context) {
    return MyCardWidget(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            docModel.name!,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  titlePadding: const EdgeInsets.all(0),
                  contentPadding: const EdgeInsets.all(0),
                  content: Image.network(docModel.url!),
                ),
              );
            },
            child: SizedBox(
              width: double.infinity,
              height: 240,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  docModel.url!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                DateFormat('hh:mm:aa, MMM dd, yyyy').format(
                    DateTime.fromMillisecondsSinceEpoch(
                        docModel.uploadTime!.toInt())),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
