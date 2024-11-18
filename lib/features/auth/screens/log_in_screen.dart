import 'package:ca_appoinment/app/routes/app_routes.dart';
import 'package:ca_appoinment/app/theme/color.dart';
import 'package:ca_appoinment/app/widgets/my_outline_button.dart';
import 'package:ca_appoinment/features/auth/bloc/auth_bloc.dart';
import 'package:ca_appoinment/features/auth/widgets/form_textfield.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/widgets/my_elevated_button.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool obscureText = false;
  String? nfToken;
  late FirebaseMessaging _firebaseMessaging;
  @override
  void initState() {
    super.initState();
    setState(() {
      
    _firebaseMessaging = FirebaseMessaging.instance;
    });
    getToken();
  }

  getToken() {
    
    _firebaseMessaging.getToken().then((token) {
      nfToken = token;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Log In User Account',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppPalates.black,
                            fontSize: 25),
                      ),
                      const SizedBox(height: 20),
                      MyTextFormField(
                          prefixIcon: Icons.alternate_email_outlined,
                          hintText: 'Email',
                          controller: emailController),
                      const SizedBox(height: 10),
                      MyTextFormField(
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
                                      color:
                                          AppPalates.primary.withOpacity(0.6))),
                          controller: passwordController),
                      const SizedBox(height: 15),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                                context, AppRoutes.forgetPasswordScreen);
                          },
                          child: const Text(
                            'Forget Password?',
                            style: TextStyle(
                                fontWeight: FontWeight.w900,
                                color: AppPalates.primary),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: double.infinity,
                        child: BlocConsumer<AuthBloc, AuthState>(
                          listener: (context, state) {
                            if (state is AuthSuccesState) {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                AppRoutes.home,
                                (route) => false,
                              );
                            }
                            if (state is AuthFailureState) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(state.errorMsg)));
                            }
                          },
                          builder: (context, state) {
                            if (state is AuthLoadingState) {
                              return MyElevatedButton(
                                btName: 'btName',
                                onTap: () {},
                                widget: const CircularProgressIndicator(
                                  color: AppPalates.white,
                                ),
                              );
                            }
                            if (state is AuthFailureState) {
                              return MyElevatedButton(
                                btName: 'Failed Retry Now',
                                onTap: () {
                                  var email = emailController.text.trim();
                                  var password = passwordController.text.trim();
                                  if (email.isNotEmpty && password.isNotEmpty) {
                                    context.read<AuthBloc>().add(AuthLoginEvent(
                                      nfToken:nfToken!,
                                        email: email, password: password));
                                  }
                                },
                              );
                            }
                            return MyElevatedButton(
                                btName: 'Log In',
                                onTap: () {
                                  if (_formKey.currentState!.validate()) {
                                    context.read<AuthBloc>().add(AuthLoginEvent(
                                      nfToken:nfToken!,
                                        email: emailController.text.trim(),
                                        password:
                                            passwordController.text.trim()));
                                  }
                                });
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.signUp);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Create User Account? ',
                          style: TextStyle(
                            decorationStyle: TextDecorationStyle.dashed,
                            fontWeight: FontWeight.w500,
                            color: AppPalates.black.withOpacity(0.6),
                          )),
                      const Text(
                        'Sign Up For Free',
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: AppPalates.primary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                MyOutlineButton(
                  btName: 'Login Professional Account',
                  onTap: () {
                    Navigator.pushNamed(
                        context, AppRoutes.professionLoginScreenScreen);
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
