// ignore_for_file: prefer__ructors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pursue/common_widgets/common_logo.dart';
import 'package:pursue/common_widgets/rounded_btn.dart';
import 'package:pursue/mobile_screens/auth/login_screen.dart';

class Intro2Screen extends StatelessWidget {
  const Intro2Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 50),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CommonLogo(
                  logoWidth: 64,
                  logoHeight: 53,
                ),
                SizedBox(height: 20),
                SvgPicture.asset(
                  "assets/images/screen_3_person.svg",
                  width: 296,
                  height: 220,
                ),
                // Spacer(),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0, right: 12),
                  child: Container(
                    height: 350,
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
                    padding: EdgeInsets.only(top: 20),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 25),
                                  child: Column(
                                    children: [
                                      SizedBox(height: 15),
                                      buildIconContent(
                                        iconPath: "assets/icons/icon_1.svg",
                                        text: "Answer a few questions",
                                      ),
                                      SizedBox(height: 15),
                                      buildIconContent(
                                        iconPath: "assets/icons/icon_4.svg",
                                        text: "Get careers suggested just for you",
                                      ),
                                      SizedBox(height: 15),
                                      buildIconContent(
                                        iconPath: "assets/icons/icon_3.svg",
                                        text: "Access top courses",
                                      ),
                                      SizedBox(height: 15),
                                      buildIconContent(
                                        iconPath: "assets/icons/icon_2.svg",
                                        text: "Pursue your chosen career path",
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20),
                                Center(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 20),
                                    child: Container(
                                     padding: EdgeInsets.symmetric(horizontal: 20),
                                     height: 50,
                                     width: double.infinity,
                                      child: RoundedButton(
                                          title: "Get Started",
                                          onTap: () {
                                            Get.to(() => LoginScreen());
                                          }),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 50),
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
                                      color: Color(0xff2F80ED),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildIconContent({required String iconPath, required String text}) {
    return Row(
      children: [
        SvgPicture.asset(
          iconPath,
          width: 21.53,
          height: 21,
        ),
        SizedBox(width: 10),
        Text(
          text,
          style: GoogleFonts.roboto(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        )
      ],
    );
  }
}
