// ignore_for_file: unused_field, must_be_immutable

import 'package:booking_calendar/booking_calendar.dart';
import 'package:ca_appoinment/app/function/appoinment_id_gen.dart';
import 'package:ca_appoinment/app/theme/color.dart';
import 'package:ca_appoinment/features/professional/profile/models/pro_account_model.dart';
import 'package:ca_appoinment/features/bookings/repository/book_appointment.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyBookingDateAndTimeWidget extends StatefulWidget {
  const MyBookingDateAndTimeWidget(
      {super.key, required this.model, required this.requirements});
  final ProfessionalAccountModel model;
  final String requirements;

  @override
  State<MyBookingDateAndTimeWidget> createState() =>
      _MyBookingDateAndTimeWidgetState();
}

class _MyBookingDateAndTimeWidgetState
    extends State<MyBookingDateAndTimeWidget> {
  BookingService? mockBookingService;
  DateTime now = DateTime.now();
  DateTime startBookingTime = DateTime.now().add(const Duration(hours: 0));

  @override
  void initState() {
    super.initState();

    // Set up the BookingService object
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        mockBookingService = BookingService(
          bookingStart: DateTime(now.year, now.month, now.day, 9),
          bookingEnd: DateTime(now.year, now.month, now.day, 19),
          serviceName: widget.model.accountType!,
          serviceId: IdGenerator.appointmentID(),
          servicePrice: 0,
          serviceDuration: 60,
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      // Simulating async initialization
      future: _initializeBookingService(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppPalates.black,
            ),
          );
        } else {
          return BookingCalendar(
            bookingService: mockBookingService!,
            availableSlotColor: AppPalates.primary,
            availableSlotTextStyle: const TextStyle(color: AppPalates.white),
            bookedSlotTextStyle: const TextStyle(
                color: AppPalates.white, fontWeight: FontWeight.bold),
            convertStreamResultToDateTimeRanges: ({streamResult}) {
              return BookAppointmentRepository.convertStreamResultFirebase(
                  streamResult: streamResult);
            },
            getBookingStream: (
                {required DateTime end, required DateTime start}) {
              return BookAppointmentRepository.getBookingStreamFirebase(
                  end: end, start: start, proModel: widget.model);
            },
            uploadBooking: ({required BookingService newBooking}) {
              return BookAppointmentRepository.uploadBookingFirebase(
                proModel: widget.model,
                requirements: widget.requirements,
                newBooking: newBooking,
                context: context,
              );
            },
            uploadingWidget: const Center(
              child: CircularProgressIndicator(
                color: AppPalates.primary,
              ),
            ),
            formatDateTime: (dt) {
              return DateFormat('hh a').format(dt);
            },
            // gridScrollPhysics: const NeverScrollableScrollPhysics(),
            bookingButtonColor: AppPalates.primary,
            startingDayOfWeek: StartingDayOfWeek.monday,
            lastDay: DateTime(now.year, now.month, now.day + 21),
            // initialStartTime: _calculateInitialStartTime(),
            pauseSlots: _calculatePausedTimes(),
          );
        }
      },
    );
  }

  // Initialize booking service (simulated async initialization)
  Future<void> _initializeBookingService() async {
    await Future.delayed(
        const Duration(seconds: 1)); // Simulating initialization delay
  }

  // Calculate initial start time based on current time

  // Calculate paused times (times that have already passed today)
  List<DateTimeRange> _calculatePausedTimes() {
    DateTime startOfToday = DateTime(now.year, now.month, now.day, 0, 0);
    List<DateTimeRange> pausedTimes = [];

    // Generate list of all times from start of today to now
    for (int hour = startOfToday.hour; hour <= now.hour; hour++) {
      DateTime startTime = DateTime(now.year, now.month, now.day, hour);
      DateTime endTime = startTime.add(const Duration(hours: 1));
      pausedTimes.add(DateTimeRange(start: startTime, end: endTime));
    }

    return pausedTimes;
  }
}
