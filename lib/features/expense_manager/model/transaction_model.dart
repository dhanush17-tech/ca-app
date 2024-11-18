
// ignore_for_file: public_member_api_docs, sort_constructors_first
class TransactionModel {
  String id;
  String title;
  int categoryId ;
  String createAt;
  String amount;
  bool income;
  TransactionModel({
    required this.id,
    required this.title,
    required this.categoryId,
    required this.createAt,
    required this.amount,
    required this.income,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'categoryId': categoryId,
      'createAt': createAt,
      'amount': amount,
      'income': income,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'] as String,
      title: map['title'] as String,
      categoryId: map['categoryId'] as int,
      createAt: map['createAt'] as String,
      amount: map['amount'] as String,
      income: map['income'] as bool,
    );
  }

}
