import 'package:ca_appoinment/app/widgets/my_drop_down.dart';
import 'package:ca_appoinment/app/widgets/my_elevated_button.dart';
import 'package:ca_appoinment/app/widgets/my_outline_button.dart';
import 'package:ca_appoinment/features/professional/auth/auth_bloc/professional_account_auth_bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ca_appoinment/app/routes/app_routes.dart';
import 'package:ca_appoinment/app/theme/color.dart';
import 'package:ca_appoinment/features/auth/widgets/form_textfield.dart';

class ProfessionalAccountSignUpScreen extends StatefulWidget {
  const ProfessionalAccountSignUpScreen({super.key});

  @override
  State<ProfessionalAccountSignUpScreen> createState() =>
      _ProfessionalAccountSignUpScreenState();
}

class _ProfessionalAccountSignUpScreenState
    extends State<ProfessionalAccountSignUpScreen> {
  final _formKeys = GlobalKey<FormState>();
  bool obscureText = false;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController accountTypeController = TextEditingController();
  String? nfToken;
  late FirebaseMessaging _firebaseMessaging;
  @override
  void initState() {
    super.initState();

    _firebaseMessaging = FirebaseMessaging.instance;

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
                  key: _formKeys,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Create Professional Accounts',
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
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: MyDropDownWidget(
                                selected: (value) {
                                  setState(() {
                                    accountTypeController.text = value!;
                                  });
                                },
                                myDropDown: const ['CA', 'FA'],
                                textEditingController: accountTypeController),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            flex: 3,
                            child: MyTextFormField(
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (!value!.contains(RegExp(
                                      r"^(\+\d{1,2}\s?)?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4}$"))) {
                                    return '• Enter valid Phone Number';
                                  }

                                  return null;
                                },
                                prefixIcon: Icons.numbers_rounded,
                                hintText: 'Phone Number',
                                controller: numberController),
                          ),
                        ],
                      ),
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
                                obscureText = !obscureText;
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
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: BlocConsumer<ProfessionalAccountAuthBloc,
                            ProfessionalAccountAuthState>(
                          listener: (context, state) {
                            if (state is ProfessionalAccountAuthSuccesState) {
                              Navigator.pushReplacementNamed(
                                  context, AppRoutes.professtionalHomeScreen);
                            }
                            if (state is ProfessionalAccountAuthFailuerState) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(state.errorMsg)));
                            }
                          },
                          builder: (context, state) {
                            if (state is ProfessionalAccountAuthLoadingState) {
                              return MyElevatedButton(
                                  btName: 'Submit',
                                  onTap: () {},
                                  widget: const CircularProgressIndicator(
                                      color: AppPalates.white));
                            }
                            return MyElevatedButton(
                              onTap: () {
                                if (_formKeys.currentState!.validate()) {
                                  context
                                      .read<ProfessionalAccountAuthBloc>()
                                      .add(ProfessionalSignUpEvent(
                                          nfToken: nfToken!,
                                          accountType:
                                              accountTypeController.text,
                                          number: numberController.text.trim(),
                                          name: nameController.text.trim(),
                                          email: emailController.text.trim(),
                                          password:
                                              passwordController.text.trim()));
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
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                        context, AppRoutes.professionLoginScreenScreen);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Already have a account?',
                          style: TextStyle(
                            decorationStyle: TextDecorationStyle.dashed,
                            fontWeight: FontWeight.w500,
                            color: AppPalates.black.withOpacity(0.6),
                          )),
                      const Text(
                        'Login here',
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: AppPalates.primary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 100),
                MyOutlineButton(
                  btName: 'Create User Account',
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.signUp);
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
