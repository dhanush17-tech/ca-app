// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:ca_appoinment/features/bookings/model/booking_time_model.dart';

class MeetingArgumnet {
  String email;
  String name;
  String profileUrl;
  String userId;
  BookingTimeModel booking;
  MeetingArgumnet({
    required this.email,
    required this.name,
    required this.booking,
    
    required this.profileUrl,
    required this.userId,
  });
}
