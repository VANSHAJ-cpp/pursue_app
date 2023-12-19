// ignore_for_file: prefer__ructors, prefer__literals_to_create_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pursue/common_widgets/apptoast.dart';
import 'package:pursue/common_widgets/common_logo.dart';
import 'package:pursue/common_widgets/rounded_btn.dart';
import 'package:pursue/mobile_screens/auth/forget_pass.dart';
import 'package:pursue/mobile_screens/chat/chat_screen1.dart';

import 'sign_in_with_email_and_pass.dart';

class SignUpWithEmailPass extends StatefulWidget {
  const SignUpWithEmailPass({Key? key}) : super(key: key);

  @override
  State<SignUpWithEmailPass> createState() => _SignUpWithEmailPassState();
}

class _SignUpWithEmailPassState extends State<SignUpWithEmailPass> {
  FirebaseAuth auth = FirebaseAuth.instance;

  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  bool passwordConfirmed() {
    if (passController.text.trim() == confirmPassController.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    confirmPassController.dispose();
    nameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 80),
          child: Column(
            children: [
              CommonLogo(
                logoWidth: 90,
                logoHeight: 70,
              ),
              SizedBox(height: 20),
              Text(
                "Create Your Account",
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                          label: Text("Name"),
                          hintText: "Enter Your Name",
                          hintStyle: TextStyle(color: Color(0xFF9FAFBC)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF2F80ED)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)))),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          label: Text("Email"),
                          hintText: "Enter Your Email",
                          hintStyle: TextStyle(color: Color(0xFF9FAFBC)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF2F80ED)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)))),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: passController,
                      obscureText: true,
                      obscuringCharacter: "*",
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                          label: Text("Password"),
                          hintText: "Enter Your Password",
                          hintStyle: TextStyle(color: Color(0xFF9FAFBC)),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF2F80ED)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)))),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: confirmPassController,
                      obscureText: true,
                      obscuringCharacter: "*",
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                          label: Text("Confirm Password"),
                          hintText: "Confirm Your Password",
                          hintStyle: TextStyle(color: Color(0xFF9FAFBC)),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF2F80ED)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)))),
                    ),
                    SizedBox(height: 10),
                    RoundedButton(
                        title: "Continue",
                        onTap: () {
                          if (passwordConfirmed() == true) {
                            signUpWithEmailAndPassword();
                          } else {
                            AppToast().toastMessage(
                                "Passwords to do match, kindly re-enter to try again");
                          }
                        }),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Align(
                alignment: Alignment.center,
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                    ),
                    children: [
                      TextSpan(
                        text: 'Already have an Account? ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Get.to(() => SignInWithEmailPass());
                          },
                        text: 'Login ',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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

  Future<void> signUpWithEmailAndPassword() async {
    try {
      final UserCredential userCredential =
          await auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passController.text,
      );
      await userCredential.user?.sendEmailVerification();
      Get.to(() => ChatScreen1());
      //specific id to know user
      var id = DateTime.now().millisecondsSinceEpoch.toString();

      adduserdetails(
        nameController.text.toString(),
        emailController.text.toString(),
        id.toString(),
      );
      AppToast().toastMessage('Successfully Created Account!');

      // Signed in
      final User? user = userCredential.user;
      if (user != null) {
        debugPrint('User signed in: ${user.email}');
        // Navigate to the next screen or perform necessary actions after sign-in
      }
    } catch (e) {
      AppToast().toastMessage(e.toString());
      debugPrint('Failed to sign in: $e');
      // Handle sign-in failure, e.g., show an error message
    }
  }

  Future adduserdetails(String id, String name, String email) async {
    await FirebaseFirestore.instance.collection('users').add({
      "id": id,
      'Name': name,
      'Email': email,
    });
  }
}
