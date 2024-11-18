// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:ca_appoinment/features/professional/profile/models/document_model.dart';

class RequiredTaxDoc {
  DocumentModel? aadhaarCard;
  DocumentModel? panCard;
  DocumentModel? bankStatement;
  RequiredTaxDoc({
    this.aadhaarCard,
    this.panCard,
    this.bankStatement,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {};

    if (aadhaarCard != null) data['aadhaarCard'] = aadhaarCard!.toMap();
    if (panCard != null) data['panCard'] = panCard!.toMap();
    if (bankStatement != null) data['bankStatement'] = bankStatement!.toMap();
    return data;
  }

  factory RequiredTaxDoc.fromMap(Map<String, dynamic> map) {
    return RequiredTaxDoc(
      aadhaarCard:
          DocumentModel.fromMap(map['aadhaarCard'] as Map<String, dynamic>),
      panCard: DocumentModel.fromMap(map['panCard'] as Map<String, dynamic>),
      bankStatement:
          DocumentModel.fromMap(map['bankStatement'] as Map<String, dynamic>),
    );
  }
}
