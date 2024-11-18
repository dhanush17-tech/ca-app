import 'package:ca_appoinment/features/professional/profile/models/client_model.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ProfessionalAccountModel {
  //
  String? userId;
  String? userName;
  String? title;
  String? email;
  String? tagLine;
  String? address;
  String? profileUrl;
  String? phoneNumber;
  String? accountType;
  String? description;
  String? createdAt;
  String? adhaarCard;
  String? panCard;
  bool verified;

//
  bool? directCall;
  bool? directMessage;
  String? experience;
  List<ClientModel>? clients;
  List<int>? workingClientsId;
//
  bool? online;
  String? lastOnline;
  bool? readyForWork;
//
  String? allowedNotifications;
  List<int>? availableTimes;
//
  List<int>? wishListAddedIds;
  List<int>? viewsIds;
  String? nfToken;
  ProfessionalAccountModel({
    this.userId,
    this.userName,
    this.title,
    this.email,
    this.tagLine,
    this.address,
    this.profileUrl,
    this.phoneNumber,
    this.accountType,
    this.description,
    this.createdAt,
    this.adhaarCard,
    this.panCard,
    this.verified = false,
    this.directCall,
    this.directMessage,
    this.experience,
    this.clients,
    this.workingClientsId,
    this.online,
    this.lastOnline,
    this.readyForWork,
    this.allowedNotifications,
    this.availableTimes,
    this.wishListAddedIds,
    this.viewsIds,
    this.nfToken,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    if (userId != null) map['userId'] = userId;
    if (userName != null) map['userName'] = userName;
    if (title != null) map['title'] = title;
    if (email != null) map['email'] = email;
    if (tagLine != null) map['tagLine'] = tagLine;
    if (address != null) map['address'] = address;
    if (profileUrl != null) map['profileUrl'] = profileUrl;
    if (phoneNumber != null) map['phoneNumber'] = phoneNumber;
    if (accountType != null) map['accountType'] = accountType;
    if (description != null) map['description'] = description;
    if (createdAt != null) map['createdAt'] = createdAt;
    if (adhaarCard != null) map['adhaarCard'] = adhaarCard;
    if (panCard != null) map['panCard'] = panCard;
    if (directCall != null) map['directCall'] = directCall;
    if (directMessage != null) map['directMessage'] = directMessage;
    if (experience != null) map['experience'] = experience;
    if (clients != null) map['clients'] = clients;
    if (workingClientsId != null) map['workingClientsId'] = workingClientsId;

    if (online != null) map['online'] = online;
    if (lastOnline != null) map['lastOnline'] = lastOnline;
    if (readyForWork != null) map['readyForWork'] = readyForWork;
    if (allowedNotifications != null) {
      map['allowedNotifications'] = allowedNotifications;
    }
    if (availableTimes != null) map['availableTimes'] = availableTimes;
    if (wishListAddedIds != null) map['wishListAddedIds'] = wishListAddedIds;
    if (viewsIds != null) map['viewsIds'] = viewsIds;
    if (nfToken != null) map['proNfToken'] = nfToken;
    map['verified'] = verified;
    return map;
  }

  factory ProfessionalAccountModel.fromMap(Map<String, dynamic> map) {
    List<ClientModel> listOfClient = [];

    if (map['clients'] != null) {
      for (ClientModel each in map['clients']) {
        listOfClient.add(each);
      }
    }

    return ProfessionalAccountModel(
      userId: map['userId'],
      profileUrl: map['profileUrl'],
      userName: map['userName'],
      title: map['title'],
      email: map['email'],
      tagLine: map['tagLine'],
      address: map['address'],
      phoneNumber: map['phoneNumber'],
      accountType: map['accountType'],
      description: map['description'],
      createdAt: map['createdAt'],
      verified: map['verified'],
      adhaarCard: map['adhaarCard'],
      panCard: map['panCard'],
      directCall: map['directCall'],
      directMessage: map['directMessage'],
      experience: map['experience'],
      nfToken: map['proNfToken'],
      clients: listOfClient,
      workingClientsId: map['workingClientsId'] != null
          ? List<int>.from((map['workingClientsId'] as List<int>))
          : null,
      online: map['online'],
      lastOnline: map['lastOnline'],
      readyForWork: map['readyForWork'],
      allowedNotifications: map['allowedNotifications'],
      availableTimes: map['availableTimes'] != null
          ? List<int>.from((map['availableTimes'] as List<int>))
          : null,
      wishListAddedIds: map['wishListAddedIds'] != null
          ? List<int>.from((map['wishListAddedIds'] as List<int>))
          : null,
      viewsIds: map['viewsIds'] != null
          ? List<int>.from((map['viewsIds'] as List<int>))
          : null,
    );
  }

  ProfessionalAccountModel copyWith({
    String? userId,
    String? userName,
    String? title,
    String? email,
    String? tagLine,
    String? address,
    String? profileUrl,
    String? phoneNumber,
    String? accountType,
    String? description,
    String? createdAt,
    String? adhaarCard,
    bool? verified,
    String? panCard,
    String? nfToken,
    bool? directCall,
    bool? directMessage,
    String? experience,
    List<ClientModel>? clients,
    List<int>? workingClientsId,
    String? afterBookedMessage,
    bool? online,
    String? lastOnline,
    bool? readyForWork,
    String? allowedNotifications,
    List<int>? availableTimes,
    List<int>? wishListAddedIds,
    List<int>? viewsIds,
  }) {
    return ProfessionalAccountModel(
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      title: title ?? this.title,
      email: email ?? this.email,
      nfToken: nfToken ?? this.nfToken,
      tagLine: tagLine ?? this.tagLine,
      address: address ?? this.address,
      profileUrl: profileUrl ?? this.profileUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      accountType: accountType ?? this.accountType,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      adhaarCard: adhaarCard ?? this.adhaarCard,
      verified: verified ?? this.verified,
      panCard: panCard ?? this.panCard,
      directCall: directCall ?? this.directCall,
      directMessage: directMessage ?? this.directMessage,
      experience: experience ?? this.experience,
      clients: clients ?? this.clients,
      workingClientsId: workingClientsId ?? this.workingClientsId,
      online: online ?? this.online,
      lastOnline: lastOnline ?? this.lastOnline,
      readyForWork: readyForWork ?? this.readyForWork,
      allowedNotifications: allowedNotifications ?? this.allowedNotifications,
      availableTimes: availableTimes ?? this.availableTimes,
      wishListAddedIds: wishListAddedIds ?? this.wishListAddedIds,
      viewsIds: viewsIds ?? this.viewsIds,
    );
  }
}
