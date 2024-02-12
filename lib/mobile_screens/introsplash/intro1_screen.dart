// ignore_for_file: prefer__ructors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pursue/common_widgets/common_logo.dart';
import 'package:pursue/common_widgets/rounded_btn.dart';
import 'package:pursue/mobile_screens/introsplash/intro2_screen.dart';
import 'package:pursue/mobile_screens/auth/login_screen.dart';

class Intro1Screen extends StatelessWidget {
  const Intro1Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          top: 40,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: Column(children: [
                  CommonLogo(
                logoWidth: 64,
                logoHeight: 53,
              ),
              SizedBox(height: 20),
              SvgPicture.asset(
                "assets/images/screen_2_person.svg",
                width: 296,
                height: 220,
              ),
                ]),
              ),
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10),
                child: Container(
                  height: 400,
                  decoration: BoxDecoration(
                    color: Colors.white,
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
                  padding: EdgeInsets.only(left: 10, right: 10, top: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 15),
                        Text(
                          "Find Your Dream Career",
                          style: GoogleFonts.roboto(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Welcome to the world of possibilities!\n Discover your true calling and find the career\n path that lights up your future.",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        SizedBox(height: 25),
                        RoundedButton(
                            title: "Next",
                            onTap: () {
                              Get.to(() => Intro2Screen());
                            }),
                        SizedBox(height: 10),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            // crossAxisAlignment: CrossAxisAlignment.end,
                            // mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Get.to(() => LoginScreen());
                                },
                                child: Text(
                                  "Skip",
                                  style: GoogleFonts.roboto(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff2F80ED),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 40,
                              height: 3,
                              color: Color(0xff2F80ED),
                            ),
                            SizedBox(width: 5),
                            Container(
                              width: 40,
                              height: 3,
                              color: Color.fromARGB(255, 42, 43, 44),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
