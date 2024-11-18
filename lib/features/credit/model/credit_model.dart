import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class CreditBalanceModel {
  int? balance;
  List<CreditModel>? history;
  CreditBalanceModel({
    required this.balance,
    required this.history,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'balance': balance,
      'history': history!.map((x) => x.toMap()).toList(),
    };
  }

  factory CreditBalanceModel.fromMap(Map<String, dynamic> map) {
    return CreditBalanceModel(
      balance: map['balance'] as int,
      history: List<CreditModel>.from(
        (map['history'] as List<dynamic>).map<CreditModel>(
          (x) => CreditModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }
}

class CreditModel {
  int amount;
  int credit;
  String email;
  String name;
  String number;
  bool increase;
  String uId;
  String orderId;
  int purchaseTime;
  CreditModel({
    required this.amount,
    required this.credit,
    required this.email,
    required this.name,
    required this.number,
    required this.increase,
    required this.uId,
    required this.orderId,
    required this.purchaseTime,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'amount': amount,
      'credit': credit,
      'email': email,
      'name': name,
      'number': number,
      'increase': increase,
      'uId': uId,
      'orderId': orderId,
      'purchaseTime': purchaseTime,
    };
  }

  factory CreditModel.fromMap(Map<String, dynamic> map) {
    return CreditModel(
      amount: map['amount'] as int,
      credit: map['credit'] as int,
      email: map['email'] as String,
      name: map['name'] as String,
      number: map['number'] as String,
      increase: map['increase'] as bool,
      uId: map['uId'] as String,
      orderId: map['orderId'] as String,
      purchaseTime: map['purchaseTime'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory CreditModel.fromJson(String source) =>
      CreditModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
