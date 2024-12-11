// ignore_for_file: prefer_const_constructors

import 'package:ai_english_learning/Screen/Admin/admin_dashboard.dart';
import 'package:ai_english_learning/Screen/Splashes/splash_screen.dart';
import 'package:ai_english_learning/Screen/User/user_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashLogo extends StatefulWidget {
  const SplashLogo({super.key});

  @override
  State<SplashLogo> createState() => _SplashLogoState();
}

class _SplashLogoState extends State<SplashLogo> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), (() {
      checkUser();
      //  Get.to(SignInPage());
    }));
  }

  checkUser() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    var userCheck = pref.getBool("Login") ?? false;
    if (userCheck) {
      var userType = pref.getString("userType");
      // Get.offAll(HumanLibrary());
      if (userType == "User") {
        Get.offAll(() => UserScreen(
              userUid: pref.getString("userUid").toString(),
              userName: pref.getString("userName").toString(),
              userEmail: pref.getString("userEmail").toString(),
            ));
      } else if (userType == "Admin") {
        Get.offAll(() => AdminDashboard(
              userName: pref.getString("userName").toString(),
              userEmail: pref.getString("userEmail").toString(),
              userUid: pref.getString("userUid").toString(),
            ));
      }
    } else {
      Get.offAll(SplashScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end:Alignment.bottomLeft,
                colors: [
              Color.fromARGB(255, 236, 236, 230),
              Color.fromARGB(255, 180, 182, 179)
            ])),
        child: Center(
          child: Image.asset('assets/images/Logo.png'),
        ),
      ),
    );
  }
}
