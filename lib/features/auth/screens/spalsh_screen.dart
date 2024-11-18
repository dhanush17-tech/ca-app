import 'dart:async';

import 'package:ca_appoinment/app/const/shared_prefrence.dart';
import 'package:ca_appoinment/app/routes/app_routes.dart';
import 'package:ca_appoinment/app/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    loginNavigate();
  }

  loginNavigate() async {
    var pref = await SharedPreferences.getInstance();
    String? user = pref.getString(SharedPrefConst.uId);
    String? userType = pref.getString(SharedPrefConst.userType);
    Timer(const Duration(milliseconds: 000), () {
      if (user != null) {
        if (user != '') {
          if (userType == SharedPrefConst.professional) {
            Navigator.pushReplacementNamed(
                context, AppRoutes.professtionalHomeScreen);
          }
          if (userType == SharedPrefConst.user) {
            Navigator.pushReplacementNamed(context, AppRoutes.home);
          }
        } else {
          Navigator.pushReplacementNamed(context, AppRoutes.signUp);
        }
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.signUp);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          ' ',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
              color: AppPalates.black),
        ),
      ),
    );
  }
}
