// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pursue/common_widgets/common_logo.dart';
import 'package:pursue/mobile_screens/chat/chat_screen1.dart';
import 'package:pursue/mobile_screens/introsplash/intro1_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    // if (auth.currentUser != null) {
    //   Timer(Duration(seconds: 3), () {
    //     Get.to(() => ChatScreen1());
    //   });
    // } else {
      Timer(Duration(seconds: 3), () {
        Get.to(() => Intro1Screen());
      });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          const CommonLogo(
            logoWidth: 100,
            logoHeight: 100,
          ),
          const Spacer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Made In India",
                    style: TextStyle(
                      color: Color(0xff050D18),
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 3),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.asset(
                      "assets/images/indian_flag.png",
                      height: 32,
                      width: 32,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}
