// import 'package:ca_appoinment/app/core/notificaton_model.dart';
import 'package:ca_appoinment/app/core/push_notification_service.dart';
import 'package:ca_appoinment/app/routes/app_routes.dart';
import 'package:ca_appoinment/app/theme/color.dart';
import 'package:ca_appoinment/features/auth/bloc/auth_bloc.dart';
import 'package:ca_appoinment/features/credit/blocs/credit_bloc/credit_bloc.dart';
import 'package:ca_appoinment/features/credit/repository/repository.dart';
import 'package:ca_appoinment/features/expense_manager/expense_bloc/expense_bloc.dart';
import 'package:ca_appoinment/features/expense_manager/provider/expense_provider.dart';
import 'package:ca_appoinment/features/fa/bloc/fa_account_bloc.dart';
import 'package:ca_appoinment/features/meeting/blocs/bloc/meeting_bloc.dart';
import 'package:ca_appoinment/features/professional/appoinments/blocs/my_appointments/my_appoinments_bloc.dart';
import 'package:ca_appoinment/features/professional/auth/auth_bloc/professional_account_auth_bloc.dart';
import 'package:ca_appoinment/features/professional/client/client_bloc/clients_bloc.dart';
import 'package:ca_appoinment/features/professional/profile/bloc/pro_user_bloc.dart';
import 'package:ca_appoinment/features/tax/bloc/ca_account_bloc/ca_account_bloc.dart';
import 'package:ca_appoinment/features/professional/profile/provider/title_discrip_provider.dart';
import 'package:ca_appoinment/features/user/blocs/booked_appointment_bloc/booked_appoinments_bloc.dart';
import 'package:ca_appoinment/features/bookings/blocs/doc_upload_bloc/doc_upload_bloc.dart';
import 'package:ca_appoinment/features/user/blocs/user_bloc/user_bloc.dart';
import 'package:ca_appoinment/app/common/providers/profile_provider.dart';
import 'package:ca_appoinment/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  PushNotificationService.initialize();

  await FirebaseMessaging.instance.requestPermission(
      sound: true, alert: true, provisional: false, badge: true);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: AppPalates.primary,
      statusBarIconBrightness: Brightness.light));
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
          create: (context) => AuthBloc(
              auth: FirebaseAuth.instance,
              firestore: FirebaseFirestore.instance)),
      BlocProvider(
          create: (context) => ProfessionalAccountAuthBloc(
              auth: FirebaseAuth.instance,
              firestore: FirebaseFirestore.instance)),
      BlocProvider(
          create: (context) => UserBloc(
              firestore: FirebaseFirestore.instance,
              firebaseStorage: FirebaseStorage.instance,
              auth: FirebaseAuth.instance)),
      BlocProvider(
          create: (context) => ExpenseBloc(
              auth: FirebaseAuth.instance,
              firestore: FirebaseFirestore.instance)),
      BlocProvider(
          create: (context) => BookedAppoinmentsBloc(
              FirebaseFirestore.instance, FirebaseAuth.instance)),
      BlocProvider(
          create: (context) => CreditBloc(FirebaseFirestore.instance,
              FirebaseAuth.instance, RazorApiRequest(), Razorpay())),
      BlocProvider(
          create: (context) =>
              ClientsBloc(FirebaseFirestore.instance, FirebaseAuth.instance)),
      BlocProvider(
          create: (context) => ProUserBloc(FirebaseFirestore.instance,
              FirebaseAuth.instance, FirebaseStorage.instance)),
      BlocProvider(
          create: (context) => DocUploadBloc(FirebaseAuth.instance,
              FirebaseFirestore.instance, FirebaseStorage.instance)),
      BlocProvider(
          create: (context) => MyAppoinmentsBloc(
              FirebaseFirestore.instance, FirebaseAuth.instance)),
      BlocProvider(
          create: (context) =>
              MeetingBloc(FirebaseFirestore.instance, FirebaseAuth.instance)),
      BlocProvider(
          create: (context) => CaAccountsBloc(FirebaseFirestore.instance)),
      BlocProvider(
          create: (context) => FaAccountBloc(FirebaseFirestore.instance)),
    ],
    child: MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ExpenseProvider()),
        ChangeNotifierProvider(create: (context) => UserProfileProvider()),
        ChangeNotifierProvider(create: (context) => TitleDescripProvider()),
      ],
      child: const MyApp(),
    ),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  User? user;
  late FirebaseMessaging _messaging;
  @override
  void initState() {
    super.initState();
    _messaging = FirebaseMessaging.instance;
    user = FirebaseAuth.instance.currentUser;

    request();
    handleNotification();
  }

  handleNotification() async {
    FirebaseMessaging.onMessage.listen((message) async {
      if (message.notification != null) {
        PushNotificationService.createNotification(message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      var page = message.data['nav'];
      if (page != null) {
        Navigator.push(context, page);
      }
    });
  }

  request() async {
    return await _messaging.requestPermission(
        sound: true, alert: true, provisional: false, badge: true);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          scaffoldBackgroundColor: AppPalates.white,
          useMaterial3: true,
          inputDecorationTheme: const InputDecorationTheme(),
          appBarTheme: const AppBarTheme(
              systemOverlayStyle: SystemUiOverlayStyle.light,
              surfaceTintColor: AppPalates.white,
              backgroundColor: AppPalates.white)),
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes(),
    );
  }
}
