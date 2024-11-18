import 'package:ca_appoinment/app/theme/color.dart';
import 'package:ca_appoinment/app/widgets/my_icon_pop_button.dart';
import 'package:ca_appoinment/app/widgets/snack_bar.dart';
import 'package:ca_appoinment/features/auth/bloc/auth_bloc.dart';
import 'package:ca_appoinment/features/auth/widgets/form_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/widgets/my_elevated_button.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  var globarKey = GlobalKey<FormState>();
  var oldPassController = TextEditingController();
  var newPassController = TextEditingController();
  String? errorMsg;
  late FirebaseAuth auth;
  @override
  void initState() {
    setState(() {
      auth = FirebaseAuth.instance;
    });
    super.initState();
  }

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
                  'Change Password',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppPalates.black,
                      fontSize: 25),
                ),
                const SizedBox(height: 20),
                MyTextFormField(
                    prefixIcon: Icons.password,
                    hintText: 'Enter Old Password',
                    controller: oldPassController),
                const SizedBox(height: 10),
                MyTextFormField(
                    prefixIcon: Icons.password,
                    hintText: 'Enter New Password',
                    controller: newPassController),
                const SizedBox(height: 10),
                BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthUpdatePassSuccess) {
                      showSnackbar(context, state.succesMsg);
                      Navigator.pop(context);
                    }
                    if (state is AuthPassUpdateFailureState) {
                      showSnackbar(context, state.errorMsg);
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
                        btName: 'Update Password',
                        onTap: () async {
                          context.read<AuthBloc>().add(AuthChangePasswordEvent(
                              oldPassword: oldPassController.text.trim(),
                              newPassword: newPassController.text.trim()));
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
