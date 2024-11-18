import 'package:ca_appoinment/app/theme/color.dart';
import 'package:ca_appoinment/app/widgets/snack_bar.dart';
import 'package:ca_appoinment/features/auth/bloc/auth_bloc.dart';
import 'package:ca_appoinment/features/auth/widgets/form_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/widgets/my_elevated_button.dart';
import '../../../app/widgets/my_icon_pop_button.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  var globarKey = GlobalKey<FormState>();
  var emailContorller = TextEditingController();
  String? errorMsg;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: const Padding(
          padding: EdgeInsets.all(3.0),
          child: MyIconPopButton(),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Form(
            key: globarKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Forget Password',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppPalates.black,
                      fontSize: 25),
                ),
                const SizedBox(height: 20),
                MyTextFormField(
                    prefixIcon: Icons.alternate_email_outlined,
                    hintText: 'Email',
                    controller: emailContorller),
                const SizedBox(height: 10),
                BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthPassUpdateFailureState) {
                      showSnackbar(context, state.errorMsg);
                    }
                    if (state is AuthUpdatePassSuccess) {
                      showSnackbar(context, state.succesMsg);
                      Navigator.pop(context);
                    }
                  },
                  builder: (context, state) {
                    if (state is AuthLoadingState) {
                      return MyElevatedButton(
                        btName: '',
                        onTap: () {},
                        widget: const CircularProgressIndicator(
                          color: AppPalates.white,
                        ),
                      );
                    }

                    return MyElevatedButton(
                        btName: 'Send Link',
                        onTap: () async {
                          if (emailContorller.text.isNotEmpty) {
                            context.read<AuthBloc>().add(
                                AuthForgetPasswordEvent(
                                    email: emailContorller.text));
                          } else {
                            showSnackbar(context, 'Enter Right Email');
                          }
                        });
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
