// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hypersdkflutter/hypersdkflutter.dart';
import 'package:pursue/common_widgets/common_logo.dart';
import 'package:pursue/common_widgets/rounded_btn.dart';
import 'package:pursue/main.dart';
import 'package:pursue/mobile_screens/chat/chat_screen1.dart';
import 'package:pursue/mobile_screens/payment/payment_screen.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

String userName = "";
String userEmail = "";
List<String> careerSuggesed = [];
class CareerResultScreen extends StatefulWidget {
  final HyperSDK hyperSDK;
  const CareerResultScreen({Key? key, required this.hyperSDK}) : super(key: key);

  @override
  State<CareerResultScreen> createState() => _CareerResultScreenState();
}

class _CareerResultScreenState extends State<CareerResultScreen> {

  int careerResLen = 0;

 @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  // String userEmail = "";

  void getUserInfo() {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final String? name = user.displayName;
      final String? email = user.email;
      print(name);
      if (name != null) {
        setState(() {
          userName = name;
          userEmail = email!;
        });

        debugPrint('Name: $userName');
        debugPrint('Email: $userEmail');
      }
    }
  }



  void initiateHyperSDK() async {
    if (!(await widget.hyperSDK.isInitialised())) {
        // Only initiate if SDK is not already initialized
        var initiatePayload = {
          "requestId": const Uuid().v4(),
          "service": "in.juspay.hyperpay",
          "payload": {
            "action": "initiate",
            "merchantId": "pursue",
            "clientId": "pursue",
            "environment": "production"
          }
        };
        await widget.hyperSDK.initiate(initiatePayload, initiateCallbackHandler);
    } else {
        // If already initialized, we can proceed to process
        proceedToPaymentScreen();
    }
}
  void initiateCallbackHandler(MethodCall methodCall) {
    if (methodCall.method == "initiate_result") {
        // Check results and based on the result decide next action
        proceedToPaymentScreen();
    }
}

void proceedToPaymentScreen() {
    // Now that we have initiated the SDK, we can navigate to the PaymentScreen
    Get.to(() => PaymentScreen(hyperSDK: widget.hyperSDK, amount: amount));
}


Future<List<String>> fetchCareerSuggestions(List<List<String>> subOptions) async {
  List<String> careerSuggestions = [];
  final response = await http.get(Uri.parse('http://54.160.218.173:80/admin/readRepository/Repository'));

  if (response.statusCode == 200) {

    List<dynamic> data = json.decode(response.body);

    for (List<String> parameters in subOptions) {
      var match = data.firstWhere((entry) {
        List<String> entryParameters = List<String>.from(entry['Parameters']);
        return entryParameters.every((param) => parameters.contains(param));
      }, orElse: () => null);

      if (match != null) {
        careerResLen = careerSuggestions.length;
        careerSuggestions.addAll(List<String>.from(match['CareerSuggestions']));
      }
    }
  } else {
    throw Exception('Failed to load data');
  }

  return careerSuggestions;
}

void main() async {
  // List<List<String>> subOptions = [
  //   ["12th", "Science", "Computer"],
  //   ["12th", "Arts", "English"]
  // ];

  try {
    List<String> suggestions = await fetchCareerSuggestions(selectedOptions);
    print('Career Suggestions: $suggestions');
  } catch (e) {
    print('Error: $e');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: 60),
              child: CommonLogo(
                logoWidth: 50,
                logoHeight: 45,
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: buildMsgContainerReceived(
              text:
                  "We have found 3 options which we feel would be a good fit to personal skills and interests!",
            ),
          ),
          // Spacer(),
          Container(
            height: 450,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(35),
                topRight: Radius.circular(35),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 1,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 20),
                    SvgPicture.asset(
                      "assets/images/success_person.svg",
                      width: 186,
                      height: 125,
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      "Your Path, Your Choice:",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Explore a world of possibility tailored exclusively for you.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Compare options, choose your preferred path, and step confidently towards your dream career.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 15),
                    SingleChildScrollView(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Limited Period Offer @ ",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            amount,
                            style: TextStyle(
                              color: Color(0xff2F80ED),
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            " Only!",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    RoundedButton(
                        title: "Grab the offer Now!",
                        onTap: () {
                          initiateHyperSDK();
                          CircularProgressIndicator();
                          // Get.to(() => PaymentScreen(hyperSDK: hyperSDK, amount: "50"));
                        }),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildMsgContainerReceived({required String text}) {
    return Container(
      padding: const EdgeInsets.all(15),
      constraints: const BoxConstraints(maxWidth: 266),
      decoration: const BoxDecoration(
        color: Color(0xffEAF2FD),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
