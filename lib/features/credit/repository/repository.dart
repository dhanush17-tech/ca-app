// ignore_for_file: body_might_complete_normally_nullable

import 'dart:convert';

import 'package:ca_appoinment/app/api_helper/apihelper.dart';
import 'package:ca_appoinment/app/function/appoinment_id_gen.dart';
import 'package:ca_appoinment/features/credit/model/credit_model.dart';
import 'package:ca_appoinment/features/credit/model/succes_credit_model.dart';
import 'package:ca_appoinment/features/credit/repository/razorpay_secrets.dart';

class RazorApiRequest {
  Future<SuccesCreditModel> makeOrder(CreditModel model) async {
    var body = {
      "amount": model.amount,
      "currency": "INR",
      "receipt": IdGenerator.creditOrderId(),
      "notes": {
        "credit": model.credit,
        "amount": model.amount,
        "email": model.email,
        "name": model.name,
        "number": model.number
      }
    };

    var res = await ApiHelper().getApi(url: RazorApiConst.orderUrl, body: jsonEncode(body));
    return SuccesCreditModel.fromJson(res);
  }
}
