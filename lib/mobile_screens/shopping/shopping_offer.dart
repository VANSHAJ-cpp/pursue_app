// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pursue/common_widgets/common_logo.dart';
import 'package:pursue/common_widgets/rounded_btn.dart';
import 'package:pursue/mobile_screens/shopping/post_payment_screen.dart';

class ShoppingOfferScreen extends StatelessWidget {
  const ShoppingOfferScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          Spacer(),
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
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                        "\u{20B9}${249}",
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
                  SizedBox(height: 30),
                  RoundedButton(
                      title: "Grab the offer Now!",
                      onTap: () {
                        Get.to(() => PostPaymentScreen());
                      }),
                  const SizedBox(height: 10),
                ],
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
