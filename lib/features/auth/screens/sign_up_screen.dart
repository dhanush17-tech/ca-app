// ignore_for_file: unused_field

import 'package:ca_appoinment/app/core/notificaton_model.dart';
import 'package:ca_appoinment/app/core/push_notification_service.dart';
import 'package:ca_appoinment/app/routes/app_routes.dart';
import 'package:ca_appoinment/app/theme/color.dart';
import 'package:ca_appoinment/features/auth/bloc/auth_bloc.dart';
import 'package:ca_appoinment/features/auth/widgets/form_textfield.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/widgets/my_elevated_button.dart';
import '../../../app/widgets/my_outline_button.dart';

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   print('handling background Message: ${message.messageId}');
//   RemoteMessage? initMessage =
//       await FirebaseMessaging.instance.getInitialMessage();
//   if (initMessage != null) {
//     PushNotification notification = PushNotification(
//         title: initMessage.notification!.title ?? '',
//         body: initMessage.notification!.body ?? '',
//         dataTitle: initMessage.data['title'] ?? '',
//         dataBody: initMessage.data['body'] ?? '');
//   }
// }

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  bool obscureText = false;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  PushNotification? _noticationInfo;
  late FirebaseMessaging _firebaseMessaging;

  String? nfToken;
  @override
  void initState() {
    super.initState();
    _firebaseMessaging = FirebaseMessaging.instance;
    register();
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
// Display Notifications;
      PushNotificationService.createNotification(message);
    });
  }

  register() async {
    await FirebaseMessaging.instance.requestPermission(
        sound: true, alert: true, provisional: false, badge: true);
    _firebaseMessaging.getToken().then((token) {
      nfToken = token;
    });
    var message = await PushNotificationService.registerNotification();

    if (message != null) {
// Display Notifications;
      PushNotificationService.createNotification(message);
    }
    var checkForInitial =
        await PushNotificationService.checkForInitialMessage();

    if (checkForInitial != null) {
// Display Notifications;
      PushNotificationService.createNotification(checkForInitial);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Sign Up',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppPalates.black,
                              fontSize: 25),
                        ),
                        const SizedBox(height: 20),
                        MyTextFormField(
                            validator: (value) {
                              if (value!.length < 5) {
                                return 'Name must be at least 5 characters';
                              }
                              return null;
                            },
                            prefixIcon: Icons.person_2_rounded,
                            hintText: 'Name',
                            controller: nameController),
                        const SizedBox(height: 10),
                        MyTextFormField(
                            validator: (value) {
                              if (!value!.contains(RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))) {
                                return '• Enter valid Email addres';
                              }

                              return null;
                            },
                            prefixIcon: Icons.alternate_email_outlined,
                            hintText: 'Email',
                            controller: emailController),
                        const SizedBox(height: 10),
                        MyTextFormField(
                            validator: (value) {
                              String errorMsg = '';
                              if (value!.length < 5) {
                                errorMsg +=
                                    '• Password must be at least 8 characters\n';
                              }
                              if (!value.contains(RegExp(r'[A-Z]'))) {
                                errorMsg += '• Uppercase letter is missing\n';
                              }
                              if (!value.contains(RegExp(r'[a-z]'))) {
                                errorMsg += '• lowercase letter is missing\n';
                              }
                              if (errorMsg == '') {
                                return null;
                              }
                              return errorMsg;
                            },
                            prefixIcon: Icons.lock_rounded,
                            hintText: 'Password',
                            isAbscured: obscureText,
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    obscureText = !obscureText;
                                  });
                                },
                                icon: obscureText
                                    ? Icon(
                                        CupertinoIcons.eye_fill,
                                        color:
                                            AppPalates.primary.withOpacity(0.7),
                                      )
                                    : Icon(CupertinoIcons.eye_slash_fill,
                                        color: AppPalates.primary
                                            .withOpacity(0.6))),
                            controller: passwordController),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: BlocConsumer<AuthBloc, AuthState>(
                            listener: (context, state) {
                              if (state is AuthSuccesState) {
                                Navigator.pushReplacementNamed(
                                    context, AppRoutes.home);
                              }
                              if (state is AuthFailureState) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(state.errorMsg)));
                              }
                            },
                            builder: (context, state) {
                              if (state is AuthLoadingState) {
                                return MyElevatedButton(
                                    btName: 'Submit',
                                    onTap: () {},
                                    widget: const CircularProgressIndicator(
                                        color: AppPalates.white));
                              }
                              return MyElevatedButton(
                                onTap: () async {
                                  if (_formKey.currentState!.validate()) {
                                    context.read<AuthBloc>().add(
                                        AuthSignUpEvent(
                                            nfToken: nfToken!,
                                            name: nameController.text.trim(),
                                            email: emailController.text.trim(),
                                            password: passwordController.text));
                                  }
                                },
                                btName: 'Submit',
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have a account? ',
                        style: TextStyle(
                          decorationStyle: TextDecorationStyle.dashed,
                          fontWeight: FontWeight.w500,
                          color: AppPalates.black.withOpacity(0.6),
                        )),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.logIn);
                      },
                      child: const Text(
                        'Login here',
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: AppPalates.primary),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 100),
                MyOutlineButton(
                  btName: 'Create Professional Account',
                  onTap: () {
                    Navigator.pushNamed(
                        context, AppRoutes.professionalAccountSignUpScreen);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
