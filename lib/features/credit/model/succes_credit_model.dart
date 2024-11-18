class SuccesCreditModel {
  int? _amount;
  int? _amountDue;
  int? _amountPaid;
  int? _attempts;
  int? _createdAt;
  String? _currency;
  String? _entity;
  String? _id;
  Notes? _notes;
  String? _offerId;
  String? _receipt;
  String? _status;

  SuccesCreditModel(
      {int? amount,
      int? amountDue,
      int? amountPaid,
      int? attempts,
      int? createdAt,
      String? currency,
      String? entity,
      String? id,
      Notes? notes,
      String? offerId,
      String? receipt,
      String? status}) {
    if (amount != null) {
      _amount = amount;
    }
    if (amountDue != null) {
      _amountDue = amountDue;
    }
    if (amountPaid != null) {
      _amountPaid = amountPaid;
    }
    if (attempts != null) {
      _attempts = attempts;
    }
    if (createdAt != null) {
      _createdAt = createdAt;
    }
    if (currency != null) {
      _currency = currency;
    }
    if (entity != null) {
      _entity = entity;
    }
    if (id != null) {
      _id = id;
    }
    if (notes != null) {
      _notes = notes;
    }
    if (offerId != null) {
      _offerId = offerId;
    }
    if (receipt != null) {
      _receipt = receipt;
    }
    if (status != null) {
      _status = status;
    }
  }

  int? get amount => _amount;
  set amount(int? amount) => _amount = amount;
  int? get amountDue => _amountDue;
  set amountDue(int? amountDue) => _amountDue = amountDue;
  int? get amountPaid => _amountPaid;
  set amountPaid(int? amountPaid) => _amountPaid = amountPaid;
  int? get attempts => _attempts;
  set attempts(int? attempts) => _attempts = attempts;
  int? get createdAt => _createdAt;
  set createdAt(int? createdAt) => _createdAt = createdAt;
  String? get currency => _currency;
  set currency(String? currency) => _currency = currency;
  String? get entity => _entity;
  set entity(String? entity) => _entity = entity;
  String? get id => _id;
  set id(String? id) => _id = id;
  Notes? get notes => _notes;
  set notes(Notes? notes) => _notes = notes;
  String? get offerId => _offerId;
  set offerId(String? offerId) => _offerId = offerId;
  String? get receipt => _receipt;
  set receipt(String? receipt) => _receipt = receipt;
  String? get status => _status;
  set status(String? status) => _status = status;

  SuccesCreditModel.fromJson(Map<String, dynamic> json) {
    _amount = json['amount'];
    _amountDue = json['amount_due'];
    _amountPaid = json['amount_paid'];
    _attempts = json['attempts'];
    _createdAt = json['created_at'];
    _currency = json['currency'];
    _entity = json['entity'];
    _id = json['id'];
    _notes = json['notes'] != null ? Notes.fromJson(json['notes']) : null;
    _offerId = json['offer_id'];
    _receipt = json['receipt'];
    _status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = _amount;
    data['amount_due'] = _amountDue;
    data['amount_paid'] = _amountPaid;
    data['attempts'] = _attempts;
    data['created_at'] = _createdAt;
    data['currency'] = _currency;
    data['entity'] = _entity;
    data['id'] = _id;
    if (_notes != null) {
      data['notes'] = _notes!.toJson();
    }
    data['offer_id'] = _offerId;
    data['receipt'] = _receipt;
    data['status'] = _status;
    return data;
  }
}

class Notes {
  int? _amount;
  int? _credit;
  String? _email;
  String? _name;
  String? _number;
  String? _uId;

  Notes(
      {int? amount, int? credit, String? email, String? name, String? number,String? uId}) {
    if (amount != null) {
      _amount = amount;
    }
    if (credit != null) {
      _credit = credit;
    }
    if (email != null) {
      _email = email;
    }
    if (name != null) {
      _name = name;
    }
    if (number != null) {
      _number = number;
    }
    if (uId != null) {
      _uId = uId;
    }
  }

  int? get amount => _amount;
  set amount(int? amount) => _amount = amount;
  int? get credit => _credit;
  set credit(int? credit) => _credit = credit;
  String? get email => _email;
  set email(String? email) => _email = email;
  String? get name => _name;
  set name(String? name) => _name = name;
  String? get number => _number;
  set number(String? number) => _number = number;
  String? get uId => _uId;
  set uId(String? uId) => _uId = uId;

  Notes.fromJson(Map<String, dynamic> json) {
    _amount = json['amount'];
    _credit = json['credit'];
    _email = json['email'];
    _name = json['name'];
    _number = json['number'];
    _uId= json['uId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = _amount;
    data['credit'] = _credit;
    data['email'] = _email;
    data['name'] = _name;
    data['number'] = _number;
    data['uId'] = _uId;
    return data;
  }
}
