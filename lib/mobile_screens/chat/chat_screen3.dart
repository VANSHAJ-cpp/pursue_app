// // ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:pursue/mobile_screens/payment/payment_screen.dart';
// import 'package:pursue/mobile_screens/shopping/career_result.dart';

// import '../../main.dart';

// class ChatScreen3 extends StatelessWidget {
//   const ChatScreen3({Key? key}) : super(key: key);

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
//           "IT Software - Telecom Software",
//       "Legal",
//       "IT Software - Application Programming",
//       "IT Software - ERP / CRM",
//       "Guards / Security Services",
//       "IT Software - Mainframe",
//       "Shopping"
//     ];
//     return Scaffold(
//       appBar: AppBar(
//         title: Center(child: Text('Select')),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Get.back();
//             },
//             child: Text(
//               'Done',
//               style: GoogleFonts.roboto(
//                 color: Color(0xff2F80ED),
//                 fontSize: 20,
//                 fontWeight: FontWeight.w400,
//               ),
//             ),
//           )
//         ],
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(height: 10),
//                   Container(
//                     height: 55,
//                     padding: const EdgeInsets.symmetric(horizontal: 20),
//                     child: TextFormField(
//                       decoration: InputDecoration(
//                         hintText: "Search",
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10.0),
//                           borderSide: BorderSide(
//                             color: Colors.grey,
//                             width: 2.0,
//                           ),
//                         ),
//                         suffixIcon: Icon(Icons.search_outlined),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 10),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 20),
//                     child: Column(
//                       children: List.generate(
//                         workTypeStringList.length,
//                         (index) => Column(
//                           children: [
//                             InkWell(
//                               onTap: () {
//                                 Get.to(() => PaymentScreen(hyperSDK: hypersdk!, amount: '249',));
//                               },
//                               child: buildInfoTiles(
//                                   text: workTypeStringList[index]),
//                             ),
//                             const SizedBox(height: 10),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 10),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Container(
//                     height: 50,
//                     padding: const EdgeInsets.symmetric(horizontal: 10),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       color: const Color(0xffECECEC),
//                     ),
//                     child: TextFormField(
//                       decoration: const InputDecoration(
//                         hintText: "Search Anything",
//                         border: InputBorder.none,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Container(
//                   width: 48,
//                   height: 48,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     color: const Color(0xff2F80ED),
//                   ),
//                   child: SvgPicture.asset(
//                     "assets/icons/send.svg",
//                     width: 27,
//                     height: 20,
//                     fit: BoxFit.scaleDown,
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//               ],
//             ),
//           ),
//         ],
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
