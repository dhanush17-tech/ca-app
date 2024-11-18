import 'package:ca_appoinment/features/professional/profile/models/document_model.dart';

import 'review_model.dart';

class ClientModel {
  String? userId;
  String? name;
  String? appinmentTime;
  String? requirementsNotes;
  List<DocumentModel?>? documents;
  ReviewModel? review;
  bool? docAllowed;
  bool? completed;
  String? completionMessage;
  ClientModel({
    this.userId,
    this.name,
    this.appinmentTime,
    this.requirementsNotes,
    this.documents,
    this.review,
    this.docAllowed,
    this.completed,
    this.completionMessage,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'name': name,
      'appinmentTime': appinmentTime,
      'requirementsNotes': requirementsNotes,
      'documents': documents!.map((x) => x!.toMap()).toList(),
      'review': review?.toMap(),
      'docAllowed': docAllowed,
      'completed': completed,
      'completionMessage': completionMessage,
    };
  }

  factory ClientModel.fromMap(Map<String, dynamic> map) {
    return ClientModel(
      userId: map['userId'],
      name: map['name'] ,
      appinmentTime:
          map['appinmentTime'] ,
      requirementsNotes: map['requirementsNotes'] ,
      documents: map['documents'] != null
          ? List<DocumentModel>.from(
              (map['documents'] as List<int>).map<DocumentModel?>(
                (x) => DocumentModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      review: map['review'] != null
          ? ReviewModel.fromMap(map['review'] as Map<String, dynamic>)
          : null,
      docAllowed: map['docAllowed'] != null ? map['docAllowed'] as bool : null,
      completed: map['completed'] != null ? map['completed'] as bool : null,
      completionMessage: map['completionMessage'] != null
          ? map['completionMessage'] as String
          : null,
    );
  }

}
