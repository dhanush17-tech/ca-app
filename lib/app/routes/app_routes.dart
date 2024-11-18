import 'package:ca_appoinment/features/auth/screens/change_password.dart';
import 'package:ca_appoinment/features/auth/screens/log_in_screen.dart';
import 'package:ca_appoinment/features/auth/screens/reset_password.dart';
import 'package:ca_appoinment/features/auth/screens/sign_up_screen.dart';
import 'package:ca_appoinment/features/auth/screens/spalsh_screen.dart';
import 'package:ca_appoinment/features/credit/screens/credit_screen.dart';
import 'package:ca_appoinment/features/credit/screens/order_details.dart';
import 'package:ca_appoinment/features/expense_manager/screen/add_expense_screen.dart';
import 'package:ca_appoinment/features/expense_manager/screen/date_wise_transation.dart';
import 'package:ca_appoinment/features/expense_manager/screen/expense.dart';
import 'package:ca_appoinment/features/meeting/screens/meeting_screen.dart';
import 'package:ca_appoinment/features/professional/appoinments/screens/send_doc_to_user.dart';
import 'package:ca_appoinment/features/professional/auth/screens/professional_account_signup.dart';
import 'package:ca_appoinment/features/professional/auth/screens/professional_login.dart';
import 'package:ca_appoinment/features/professional/client/screen/client_info_screen.dart';
import 'package:ca_appoinment/features/professional/professional_home.dart';
import 'package:ca_appoinment/features/professional/profile/screens/update_service_info.dart';
import 'package:ca_appoinment/features/professional/profile/screens/user_personal_info.dart';
import 'package:ca_appoinment/features/bookings/screens/appointment_booking_screen.dart';
import 'package:ca_appoinment/features/tax/screens/tax_filling_details_screen.dart';
import 'package:ca_appoinment/features/user/screen/booked_appoinment.dart';
import 'package:ca_appoinment/features/user/screen/uploaded_documnet_scree.dart';
import 'package:ca_appoinment/features/bookings/screens/document_upload_screen.dart';
import 'package:ca_appoinment/features/user/screen/personal_info_screen.dart';
import 'package:ca_appoinment/features/user/screen/user_screen.dart';
import 'package:ca_appoinment/home.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String home = '/home';
  //Authentication Screems
  static const String splash = '/splash';
  static const String logIn = '/logIn';
  static const String signUp = '/signUp';
  static const String forgetPasswordScreen = '/forgetPasswordScreen';
  static const String changePasswordScreen = '/changePasswordScreen';
// Professional Account Auth
  static const String professionalAccountSignUpScreen =
      '/professionalAccountSignUpScreen';
  static const String professionLoginScreenScreen =
      '/professionLoginScreenScreen';
  static const String professtionalHomeScreen = '/professtionalHomeScreen';
  static const String clientInfoScreen = '/clientInfoScreen';
  static const String sendDocsToUser = '/SendDocsToUser';

  //Expense screen
  static const String expense = '/expense';
  static const String addExpense = '/addExpense';
  static const String seeAllTransation = '/SeeAllTransation';

  //Normal users Screen
  static const String profile = '/profile';
  static const String personalInfoScreen = '/personalInfoScreen';
  static const String docUploadScreen = '/docUploadScreen';

  //Tax Features Screens
  static const String taxFillingDetailsScreen = '/taxFillingDetailsScreen';
  static const String appointmentBookingScreen = '/appointmentBookingScreen';
  static const String bookedSuccces = '/bookedSuccces';
  static const String bookedAppoinmnetScreen = '/BookedAppoinmnetScreen';
  static const String proPersonalInfoScreen = '/ProPersonalInfoScreen';
  static const String meetingScreen = '/MeetingScreen';
  static const String uploadedDocuments = '/UploadedDocuments';
  static const String updateServiceInfo = '/UpdateServiceInfo';

  // Credit Features Screens
  static const String creditScreen = '/CreditScreen';
  static const String orderDetails = '/orderDetails';
  static Map<String, Widget Function(BuildContext)> routes() {
    return {
      home: (p0) => const Home(),
      logIn: (p0) => const LogInScreen(),
      signUp: (p0) => const SignUpScreen(),
      splash: (p0) => const SplashScreen(),
      profile: (p0) => const UserProfile(),
      addExpense: (p0) => const AddexpenseScreen(),
      expense: (p0) => const ExpenseScreen(),
      personalInfoScreen: (p0) => const PersonalInfoScreen(),
      forgetPasswordScreen: (p0) => const ForgetPasswordScreen(),
      changePasswordScreen: (p0) => const ChangePasswordScreen(),
      taxFillingDetailsScreen: (p0) => const TaxFillingDetailsScreen(),
      appointmentBookingScreen: (p0) => const AppointmentBookingScreen(),
      professionalAccountSignUpScreen: (p0) =>
          const ProfessionalAccountSignUpScreen(),
      professionLoginScreenScreen: (p0) => const ProfessionLoginScreenScreen(),
      professtionalHomeScreen: (p0) => const ProfesstionalHomeScreen(),
      bookedAppoinmnetScreen: (p0) => const BookedAppoinmnetScreen(),
      proPersonalInfoScreen: (p0) => const ProPersonalInfoScreen(),
      meetingScreen: (p0) => const MeetingScreen(),
      seeAllTransation: (p0) => const SeeAllTransation(),
      docUploadScreen: (p0) => const DocUploadScreen(),
      uploadedDocuments: (p0) => const UploadedDocuments(),
      updateServiceInfo: (p0) => const UpdateServiceInfo(),
      clientInfoScreen: (p0) => const ClientInfoScreen(),
      sendDocsToUser: (p0) => const SendDocsToUser(),
      creditScreen: (p0) => const CreditScreen(),
      orderDetails: (p0) => const OrderDetails(),
    };
  }
}
