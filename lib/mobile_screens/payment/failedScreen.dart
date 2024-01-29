import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pursue/common_widgets/rounded_btn.dart';
import 'package:pursue/main.dart';
import 'package:pursue/mobile_screens/payment/payment_screen.dart';
import 'package:pursue/mobile_screens/shopping/career_result.dart';

class FailedScreen extends StatefulWidget {
  const FailedScreen({super.key});

  @override
  State<FailedScreen> createState() => _FailedScreenState();
}

class _FailedScreenState extends State<FailedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.red,
              size: 100,
            ),
            SizedBox(height: 20),
            Text(
              'Payment Failed!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            RoundedButton(
              title: "Retry",
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (_) => PaymentScreen(
                            hyperSDK: hyperSDK,
                            amount: '1',
                          )),
                );
              },
            ),
            RoundedButton(
              title: "Go to home page",
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (_) => CareerResultScreen(hyperSDK: hyperSDK)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
