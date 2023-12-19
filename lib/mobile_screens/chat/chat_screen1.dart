// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pursue/common_widgets/common_logo.dart';
import 'package:pursue/mobile_screens/chat/chat_screen2.dart';

class ChatScreen1 extends StatelessWidget {
  const ChatScreen1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 60),
                  child: CommonLogo(
                    logoWidth: 50,
                    logoHeight: 45,
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildMsgContainerReceived(
                        text:
                            "Hello! Welcome to Pursue. Be ready to find what all you can pursue.",
                      ),
                      const SizedBox(height: 10),
                      buildMsgContainerReceived(text: "Enter Your Name"),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.end,
                      //   children: [
                      //     buildMsgContainerSender(text: "Sarvesh"),
                      //   ],
                      // ),
                    ],
                  ),
                ],
              ),
            ),
            bottomInput(),
          ],
        ),
      ),
    );
  }

  Widget buildMsgContainerReceived({required String text}) {
    return IntrinsicHeight(
      child: Container(
        padding: EdgeInsets.all(10),
        constraints: const BoxConstraints(
          maxWidth: 266,
          maxHeight: 100,
        ),
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
      ),
    );
  }

  Widget buildMsgContainerSender({required String text}) {
    return IntrinsicHeight(
      child: Container(
        padding: EdgeInsets.all(10),
        constraints: const BoxConstraints(
          maxWidth: 266,
          maxHeight: 100,
        ),
        decoration: const BoxDecoration(
          color: Color(0xff2F80ED),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget bottomInput() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xffECECEC),
              ),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: "Type a message...",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          InkWell(
            onTap: () {
              Get.to(() => ChatScreen2());
            },
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xff2F80ED),
              ),
              child: SvgPicture.asset(
                "assets/icons/send.svg",
                width: 19,
                height: 19,
                fit: BoxFit.scaleDown,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
