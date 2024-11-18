// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:ca_appoinment/features/professional/profile/models/document_model.dart';
import 'package:ca_appoinment/features/bookings/model/required_doc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookingTimeModel {
  // client User
  final String? userId;
  final String? userName;
  final String? userEmail;
  final String? userPhoneNumber;
  final String? userProfileUrl;
  final String? requirements;
  final String? userNfToken;
  final RequiredTaxDoc? userDocs;
  // Professional User
  final String? proId;
  final String? proName;

  final String? proNfToken;
  final String? proEmail;
  final String? proPhoneNumber;
  final String? proProfileUrl;
  final DocumentModel? caDocs;
  //Service Details
  final String? serviceID;
  final String? serviceName;
  final int? serviceDuration;
  final int? servicePrice;
  //Service Time
  final DateTime? bookingStart;
  final DateTime? bookingEnd;
  final String? status;
  BookingTimeModel(
      {this.userId,
      this.userName,
      this.userEmail,
      this.userPhoneNumber,
      this.userProfileUrl,
      this.requirements,
      this.userDocs,
      this.caDocs,
      this.proId,
      this.proNfToken,
      this.userNfToken,
      this.proName,
      this.proEmail,
      this.proPhoneNumber,
      this.proProfileUrl,
      this.serviceID,
      this.serviceName,
      this.serviceDuration,
      this.servicePrice,
      this.bookingStart,
      this.bookingEnd,
      this.status});

  // Convert Timestamp to DateTime
  static DateTime? timeStampToDateTime(dynamic timestamp) {
    if (timestamp is Timestamp) {
      return timestamp.toDate();
    } else if (timestamp is String) {
      return DateTime.parse(timestamp);
    }
    return null;
  }

  // Convert DateTime to Timestamp
  static Timestamp? dateTimeToTimeStamp(DateTime? dateTime) {
    return dateTime != null ? Timestamp.fromDate(dateTime) : null;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'userName': userName,
      'userEmail': userEmail,
      'userPhoneNumber': userPhoneNumber,
      'userProfileUrl': userProfileUrl,
      'requirements': requirements,
      'userDocs': userDocs,
      'caDocs': caDocs,
      'proId': proId,
      'proName': proName,
      'proEmail': proEmail,
      'proNfToken': proNfToken,
      'userNfToken': userNfToken,
      'proPhoneNumber': proPhoneNumber,
      'proProfileUrl': proProfileUrl,
      'serviceID': serviceID,
      'serviceName': serviceName,
      'serviceDuration': serviceDuration,
      'servicePrice': servicePrice,
      'status': status,
      'bookingStart': dateTimeToTimeStamp(bookingStart),
      'bookingEnd': dateTimeToTimeStamp(bookingEnd),
    };
  }

  factory BookingTimeModel.fromMap(Map<String, dynamic> map) {
    return BookingTimeModel(
      userId: map['userId'] != null ? map['userId'] as String : null,
      proNfToken:
          map['proNfToken'] != null ? map['proNfToken'] as String : null,
      userNfToken:
          map['userNfToken'] != null ? map['userNfToken'] as String : null,
      userName: map['userName'] != null ? map['userName'] as String : null,
      userEmail: map['userEmail'] != null ? map['userEmail'] as String : null,
      userPhoneNumber: map['userPhoneNumber'] != null
          ? map['userPhoneNumber'] as String
          : null,
      userProfileUrl: map['userProfileUrl'] != null
          ? map['userProfileUrl'] as String
          : null,
      requirements:
          map['requirements'] != null ? map['requirements'] as String : null,
      userDocs: map['userDocs'] != null
          ? RequiredTaxDoc.fromMap(map['userDocs'])
          : null,
      caDocs:
          map['caDocs'] != null ? DocumentModel.fromMap(map['caDocs']) : null,
      proId: map['proId'] != null ? map['proId'] as String : null,
      proName: map['proName'] != null ? map['proName'] as String : null,
      proEmail: map['proEmail'] != null ? map['proEmail'] as String : null,
      proPhoneNumber: map['proPhoneNumber'] != null
          ? map['proPhoneNumber'] as String
          : null,
      proProfileUrl:
          map['proProfileUrl'] != null ? map['proProfileUrl'] as String : null,
      serviceID: map['serviceID'] != null ? map['serviceID'] as String : null,
      serviceName:
          map['serviceName'] != null ? map['serviceName'] as String : null,
      serviceDuration:
          map['serviceDuration'] != null ? map['serviceDuration'] as int : null,
      servicePrice:
          map['servicePrice'] != null ? map['servicePrice'] as int : null,
      status: map['status'] != null ? map['status'] as String : null,
      bookingStart: timeStampToDateTime(map['bookingStart']),
      bookingEnd: timeStampToDateTime(map['bookingEnd']),
    );
  }

  BookingTimeModel copyWith({
    String? userId,
    String? userName,
    String? userEmail,
    String? userPhoneNumber,
    String? userProfileUrl,
    String? requirements,
    RequiredTaxDoc? userDocs,
    String? proId,
    String? proName,
    String? proEmail,
    String? proPhoneNumber,
    String? proProfileUrl,
    String? serviceID,
    String? serviceName,
    int? serviceDuration,
    int? servicePrice,
    DateTime? bookingStart,
    DateTime? bookingEnd,
    String? status,
  }) {
    return BookingTimeModel(
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      userPhoneNumber: userPhoneNumber ?? this.userPhoneNumber,
      userProfileUrl: userProfileUrl ?? this.userProfileUrl,
      requirements: requirements ?? this.requirements,
      userDocs: userDocs ?? this.userDocs,
      proId: proId ?? this.proId,
      proName: proName ?? this.proName,
      proEmail: proEmail ?? this.proEmail,
      proPhoneNumber: proPhoneNumber ?? this.proPhoneNumber,
      proProfileUrl: proProfileUrl ?? this.proProfileUrl,
      serviceID: serviceID ?? this.serviceID,
      serviceName: serviceName ?? this.serviceName,
      serviceDuration: serviceDuration ?? this.serviceDuration,
      servicePrice: servicePrice ?? this.servicePrice,
      bookingStart: bookingStart ?? this.bookingStart,
      bookingEnd: bookingEnd ?? this.bookingEnd,
      status: status ?? this.status,
    );
  }
}
