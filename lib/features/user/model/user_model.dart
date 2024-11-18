
// ignore_for_file: public_member_api_docs, sort_constructors_first

class UserModel {
  String? uId;
  String? name;
  String? email;
  String? accountCreatedDate;
  String? profilePic;
  String? accountType;
  String? bithDate;
  String? gender;
  String? number;
  String? nfToken;
  int? credit;
  UserModel({
    this.uId,
    this.name,
    this.email,
    this.accountCreatedDate,
    this.profilePic,
    this.accountType,
    this.bithDate,
    this.gender,
    this.number,
    this.nfToken,
    this.credit,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uId': uId,
      'name': name,
      'email': email,
      'accountCreatedDate': accountCreatedDate,
      'profilePic': profilePic,
      'accountType': accountType,
      'bithDate': bithDate,
      'gender': gender,
      'number': number,
      'nfToken': nfToken,
      'credit': credit,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uId: map['uId'] != null ? map['uId'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      accountCreatedDate: map['accountCreatedDate'] != null ? map['accountCreatedDate'] as String : null,
      profilePic: map['profilePic'] != null ? map['profilePic'] as String : null,
      accountType: map['accountType'] != null ? map['accountType'] as String : null,
      bithDate: map['bithDate'] != null ? map['bithDate'] as String : null,
      gender: map['gender'] != null ? map['gender'] as String : null,
      number: map['number'] != null ? map['number'] as String : null,
      nfToken: map['nfToken'] != null ? map['nfToken'] as String : null,
      credit:  map['credit'] != null ? map['credit'] as int : null,
    );
  }

}
