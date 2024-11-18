// ignore_for_file: public_member_api_docs, sort_constructors_first


class DocumentModel {
  String? docId;
  String? url;
  String? name;
  int? uploadTime;
  DocumentModel({
    this.docId,
    this.url,
    this.name,
    this.uploadTime,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'url': url,
      'name': name,
      'uploadTime': uploadTime,
    };
  }

  factory DocumentModel.fromMap(Map<String, dynamic> map) {
    return DocumentModel(
      docId: map['docId'] != null ? map['docId'] as String : null,
      url: map['url'] != null ? map['url'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      uploadTime: map['uploadTime'] != null ? map['uploadTime'] as int : null,

    );
  }


}
