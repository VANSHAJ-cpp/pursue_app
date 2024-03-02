// ignore_for_file: prefer__ructors, prefer__literals_to_create_immutables, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pursue/common_widgets/apptoast.dart';
import 'package:pursue/mobile_screens/shopping/career_result.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pursue/common_widgets/common_logo.dart';
import 'package:pursue/mobile_screens/chat/chat_screen1.dart';
import 'package:http/http.dart' as http;
import 'package:pursue/mobile_screens/auth/sign_up_with_emailandpass.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Uri url = Uri.parse('https://flutter.dev');

  Future openLink() async {
    const url = 'https://pursueit.in/privacypolicy/';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(top: 90),
        child: Center(
          child: Column(
            children: [
              CommonLogo(
                logoWidth: 130,
                logoHeight: 80,
              ),
              Spacer(),
              Container(
                height: 307,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.only(
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
                  padding: EdgeInsets.only(left: 20, right: 20, top: 30),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      InkWell(
                        onTap: signInWithGoogle,
                        child: buildIconContent(
                          iconPath: "assets/images/google_logo.svg",
                          text: "Continue with Google",
                        ),
                      ),
                      SizedBox(height: 15),
                      InkWell(
                        onTap: () {
                          Get.to(() => SignUpWithEmailPass());
                        },
                        child: buildIconContent(
                          iconPath: "assets/images/mail_logo.svg",
                          text: "Sign up with email",
                        ),
                      ),
                      SizedBox(height: 20),
                      InkWell(
                        onTap: () {
                          openLink();
                        },
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: "By creating an account, you agree with our ",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                            children: [
                              TextSpan(
                                text: "Terms and Conditions",
                                style: TextStyle(
                                  color: Colors.white,
                                  // decoration: TextDecoration.underline,
                                ),
                              ),
                              TextSpan(text: " & "),
                              TextSpan(
                                text: "Privacy Policy",
                                style: TextStyle(
                                  color: Colors.white,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildIconContent({required String iconPath, required String text}) {
    return Container(
      width: 364,
      height: 51,
      padding: EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            iconPath,
            width: 20,
            height: 20,
          ),
          SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          )
        ],
      ),
    );
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);

        debugPrint(userCredential.user?.displayName);

        String email = userCredential.user!.email.toString();
        String name = userCredential.user!.displayName.toString();
        debugPrint(name);

        if (userCredential.user != null) {
          Get.to(() => ChatScreen1());
          AppToast().toastMessage(
              "You're Signing in with your Google Account : $email");
        }
        userName = name;
        userEmail = email;
        var id = DateTime.now().millisecondsSinceEpoch.toString();
        createUser(
          id,
          name,
          email,
        );
      }
    } catch (e) {
      AppToast().toastMessage("Error signing in with Google! please try after some time or try signing up");
      debugPrint('Error signing in with Google: $e');
    }
  }

  Future<void> createUser(String id, String name, String email) async {
    // Define the endpoint URL
    String apiUrl = 'https://54.160.218.173:80/user/addUser';
    Map<String, dynamic> userData = {
      'UserID': id,
      'OrderID': "__",
      'CustomerID': "CID$id",   
      'Name': name,
      'Email': email,
      'PhoneNumber': 0,
      'DidStartChatbot': false,
      'IsPaidUser': false,
      'Options': [],
      'FinalCareerOptions': [],
    };
    String requestBody = jsonEncode(userData);

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: requestBody,
      );
      if (response.statusCode == 200) {
        print('User created successfully');
      } else {
        print('Failed to create user. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error creating user: $error');
    }
  }

  Future<void> addDataIfNotExists(String fieldValue) async {
    final firestore = FirebaseFirestore.instance;
    final collection = firestore.collection('users');

    final existingDocs =
        await collection.where('Email', isEqualTo: fieldValue).get();

    if (existingDocs.docs.isEmpty) {
      await collection.add({'fieldName': fieldValue});
      debugPrint('Data added successfully');
    } else {
      debugPrint('Data already exists');
    }
  }
}
