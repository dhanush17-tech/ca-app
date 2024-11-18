// ignore_for_file: library_prefixes

import 'dart:convert';
import 'dart:io';
import 'package:ca_appoinment/app/api_helper/app_exeptions.dart';
import 'package:ca_appoinment/features/credit/repository/razorpay_secrets.dart';
import 'package:http/http.dart' as httpClient;

class ApiHelper {
  Future<dynamic> getApi({required String url, required var body}) async {
    var uri = Uri.parse(url);
    try {
      var response = await httpClient.post(uri,
          body: body, headers: RazorApiConst.headers);
      return returnDataResponse(response);
    } on SocketException {
      throw FetchDataException(body: 'Internet Error');
    }
  }

  dynamic returnDataResponse(httpClient.Response response) {
    switch (response.statusCode) {
      case 200:
        return jsonDecode(response.body);
      case 400:
        print(response.body);
        throw BadRequestException(body: response.body);
      case 401:
      case 403:
        throw UnauthorizedException(body: response.body);
      case 500:
      default:
        throw FetchDataException(
            body:
                'Error Occured While Communication With Server With StatusCode : ${response.body}');
    }
  }
}
