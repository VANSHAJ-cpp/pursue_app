// // ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:hypersdkflutter/hypersdkflutter.dart';
// import 'package:pursue/common_widgets/common_logo.dart';
// import 'package:pursue/main.dart';
// import 'package:pursue/mobile_screens/chat/chat_screen3.dart';
// import 'package:pursue/mobile_screens/payment/payment_screen.dart';
// import 'package:pursue/mobile_screens/shopping/career_result.dart';

// class ChatScreen2 extends StatelessWidget {
//   const ChatScreen2({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final workTypeStringList = [
//       "IT Software - Telecom Software",
//       "Legal",
//       "IT Software - Application Programming",
//       "IT Software - ERP / CRM",
//       "Guards / Security Services",
//       "IT Software - Mainframe",
//       "Shopping"
//     ];
//     return Scaffold(
//       body: Column(
//         children: [
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.only(top: 60),
//                           child: CommonLogo(logoWidth: 50, logoHeight: 45),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 30),
//                     buildMsgContainerReceived(
//                         text:
//                             "Great, now select from the below option you are most interested to."),
//                     const SizedBox(height: 15),
//                     Column(
//                       children: List.generate(
//                         7,
//                         (index) => Column(
//                           children: [
//                             InkWell(
//                               onTap: () {
//                                 Get.to(() => PaymentScreen(amount: '249', hyperSDK: ,));
//                               },
//                               child: buildInfoTiles(
//                                   text: workTypeStringList[index]),
//                             ),
//                             const SizedBox(height: 10),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           Column(
//             children: [
//               Align(
//                 alignment: Alignment.center,
//                 child: GestureDetector(
//                   onTap: () {
//                     Get.to(() => ChatScreen3());
//                   },
//                   child: Text(
//                     "Load More",
//                     style: GoogleFonts.roboto(
//                       fontSize: 20,
//                       fontWeight: FontWeight.w500,
//                       color: Color(0xff2F80ED),
//                     ),
//                   ),
//                 ),
//               ),
//               Divider(thickness: .5),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 10),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: Container(
//                         height: 50,
//                         padding: const EdgeInsets.symmetric(horizontal: 10),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(10),
//                           color: const Color(0xffECECEC),
//                         ),
//                         child: TextFormField(
//                           decoration: const InputDecoration(
//                             hintText:
//                                 "Click on Load More or Start typing to search",
//                             border: InputBorder.none,
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 10),
//                     Container(
//                       width: 48,
//                       height: 48,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10),
//                         color: const Color(0xff2F80ED),
//                       ),
//                       child: SvgPicture.asset(
//                         "assets/icons/send.svg",
//                         width: 27,
//                         height: 20,
//                         fit: BoxFit.scaleDown,
//                       ),
//                     ),
//                     const SizedBox(width: 10),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget buildMsgContainerReceived({required String text}) {
//     return Container(
//       padding: const EdgeInsets.all(10),
//       constraints: const BoxConstraints(maxWidth: 266),
//       decoration: const BoxDecoration(
//         color: Color(0xffEAF2FD),
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(25),
//           topRight: Radius.circular(25),
//           bottomRight: Radius.circular(25),
//         ),
//       ),
//       child: Text(
//         text,
//         style: const TextStyle(
//           fontSize: 16,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//     );
//   }

//   Widget buildInfoTiles({required String text}) {
//     return Container(
//       height: 50,
//       decoration: BoxDecoration(
//         color: const Color(0xffBFDCFF),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Center(
//         child: Text(
//           text,
//           textAlign: TextAlign.center,
//         ),
//       ),
//     );
//   }
// }
