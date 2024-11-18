
class ReviewModel {
  String? id;
  String? rate;
  String? title;
  String? discription;
  String? createdAt;
  String? userName;
  String? userId;
  ReviewModel({
    this.id,
    this.rate,
    this.title,
    this.discription,
    this.createdAt,
    this.userName,
    this.userId
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'rate': rate,
      'title': title,
      'discription': discription,
      'createdAt': createdAt,
      'userName': userName,
      'userId':userId
    };
  }

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      id: map['id'] != null ? map['id'] as String : null,
      rate: map['rate'] != null ? map['rate'] as String : null,
      title: map['title'] != null ? map['title'] as String : null,
      discription:
          map['discription'] != null ? map['discription'] as String : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      userName: map['userName'] != null ? map['userName'] as String : null,
      userId: map['userId'] != null ? map['userId'] as String : null,
    );
  }

}
