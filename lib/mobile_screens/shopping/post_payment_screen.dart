// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pursue/common_widgets/rounded_btn.dart';
import 'package:pursue/mobile_screens/auth/login_screen.dart';
import 'package:get/get.dart';
import 'package:pursue/common_widgets/apptoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PostPaymentScreen extends StatefulWidget {
  const PostPaymentScreen({Key? key}) : super(key: key);

  @override
  State<PostPaymentScreen> createState() => _PostPaymentScreenState();
}

class _PostPaymentScreenState extends State<PostPaymentScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  String userName = "";
  String userEmail = "";
  List<dynamic> careerData = [];
  String? careerName;
  String? currCareerName;

  List<dynamic> _messageCareerPath = [];
  List<dynamic> _messsageSkills = [];
  String? _messageDescription;
  List<dynamic> _messageCourses = [];
  List<dynamic> _messageTopColleges = [];
  List<dynamic> _messageExpectedSalary = [];

  @override
  void initState() {
    super.initState();
    getUserInfo();
    fetchData();
  }

  void getUserInfo() {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final String? name = user.displayName;
      final String? email = user.email;
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

  Future<void> fetchData() async {
    final response = await http
        .get(Uri.parse('http://54.160.218.173:8080/admin/careerDescription'));
    print(response.statusCode);
    if (response.statusCode == 200) {
      // setState(() {
      careerData = json.decode(response.body)['result'];
      print(careerData.length);
      // });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Text(
              "Welcome!",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 5),
            Text(
              userName,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(width: 5),
            SvgPicture.asset(
              "assets/images/pursue_logo.svg",
              width: 20,
              height: 20,
              fit: BoxFit.contain,
            ),
          ],
        ),
        actions: [
          CircleAvatar(
            radius: 19,
            child: IconButton(
                tooltip: "Logout",
                onPressed: () async {
                  try {
                    getUserInfo();
                    await auth.signOut();
                    Get.to(() => LoginScreen());
                    AppToast().toastMessage("Successfully Logged Out!");
                  } catch (e) {
                    AppToast().toastMessage(e.toString());

                    debugPrint('Failed to sign in: $e');
                  }
                },
                icon: Icon(
                  Icons.logout_outlined,
                  size: 25,
                )),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: CustomScrollView(
          slivers: [
            toSliverBox(buildCareerInfo),
            toSliverBox(const SizedBox(height: 15)),
            toSliverBox(buildCareerSuggestionSection),
            toSliverBox(const SizedBox(height: 20)),
            toSliverBox(buildCareerAbout),
            toSliverBox(const SizedBox(height: 20)),
            toSliverBox(buildCareerPathSteps),
            toSliverBox(const SizedBox(height: 20)),
            toSliverBox(buildAverageSalariesSection),
            toSliverBox(const SizedBox(height: 20)),
            toSliverBox(buildTopCollegesSection),
            toSliverBox(const SizedBox(height: 20)),
            toSliverBox(buildSkillsSection),
            toSliverBox(const SizedBox(height: 20)),
            toSliverBox(buildCoursesSection),
            toSliverBox(const SizedBox(height: 20)),
            toSliverBox(buildShareCard),
            toSliverBox(const SizedBox(height: 50)),
          ],
        ),
      ),
    );
  }

  Widget toSliverBox(Widget child) {
    return SliverToBoxAdapter(child: child);
  }

  Widget get buildCareerInfo {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [
            Color(0xff368EEE),
            Color(0xff44A9F0),
            Color(0xff4FBEF1),
          ],
        ),
      ),
      child: const Text(
        "Careers suggested as per your unique Skills and Interests",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget get buildCareerSuggestionSection {
    return FutureBuilder(
      future: fetchData(),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.done){
          return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Career Suggestions",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Image.asset(
                  "assets/images/screen_10_slide_arrow.png",
                  width: 30,
                  height: 15,
                  fit: BoxFit.contain,
                ),
              ],
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ...List.generate(
                    careerData.length,
                    (index) => Row(
                      children: [
                        buildCareerOption(
                          isSelected: isSelectedList[index],
                          text: careerData[index]['Name'].toString(),
                          onTap: () {
                            setState(() {
                              isSelectedList =
                                  List.generate(10, (i) => i == index);
                              _messageExpectedSalary =
                                  careerData[index]["AverageSalaries"];
                              _messageCareerPath =
                                  careerData[index]['CareerPathSteps'];
                              careerName = careerData[index]['Name'];
                              currCareerName = careerName.toString();
                              _messageDescription =
                                  careerData[index]['Description'];
                              _messageCourses = careerData[index]['Courses'];
                              _messageTopColleges =
                                  careerData[index]['TopColleges'];
                              _messsageSkills = careerData[index]['Skills'];
                              
                            });
                          },
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      );
        }else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        
      },
    );
  }

  List<bool> isSelectedList = List.generate(10, (index) => false);

  Widget buildCareerOption({
    required bool isSelected,
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 45,
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isSelected ? const Color(0xff3183ED) : null,
          border: Border.all(
            width: 2,
            color:
                isSelected ? const Color(0xff3183ED) : const Color(0xff3183ED),
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

// Career details depend on type of btn tapped.
  Widget get buildCareerAbout {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            currCareerName.toString(),
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Coders design and create computer systems and applications to solve '
            "real-world problems.",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          ...List.generate(
            5,
            (_) => const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 10),
                Column(
                  children: [
                    Text(
                      "\u25CF",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Designing and maintaining software Designing and maintaining softwareDesigning and maintaining software",
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget get buildCareerPathSteps {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Career path in steps:",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        ...List.generate(
          5,
          (index) {
            if (index == 4) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 3,
                    ),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xff4DBAF1),
                    ),
                    child: Text(
                      "${index + 1}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      "Complete 11th and 12th grade with science and mathematics as your main subjects.",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              );
            }
            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 3,
                        ),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xff4DBAF1),
                        ),
                        child: Text(
                          "${index + 1}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      ...List.generate(
                        20,
                        (index) {
                          if (index % 2 != 0) {
                            return const SizedBox(height: 3);
                          }
                          return Container(
                            height: 3,
                            width: 2,
                            color: Colors.black,
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      "Complete 11th and 12th grade with science and mathematics as your main subjects.",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        )
      ],
    );
  }

  Widget get buildAverageSalariesSection {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Average Salaries",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 133,
                child: Stack(
                  children: [
                    Positioned(
                      top: 10,
                      child: Container(
                        height: 133,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 20,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: const Color(0xffDFF5FD),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "INR 3,00,000",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xff2F80ED),
                              ),
                            ),
                            Text(
                              "to",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Color(0xff2F80ED),
                              ),
                            ),
                            Text(
                              "INR 4,00,000",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xff2F80ED),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 3,
                          horizontal: 5,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(width: 10),
                            Text(
                              "Entry-level",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(width: 10),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: SizedBox(
                height: 133,
                child: Stack(
                  children: [
                    Positioned(
                      top: 10,
                      child: Container(
                        height: 133,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 20,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: const Color(0xffBFE1FC),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "INR 8,00,000",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              "to",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              "INR 12,00,000",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 3,
                          horizontal: 5,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(width: 10),
                            Text(
                              "Experienced",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(width: 10),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget get buildTopCollegesSection {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Top Colleges",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 20),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ...List.generate(
                10,
                (index) => Row(
                  children: [
                    SizedBox(
                      width: 200,
                      height: 220,
                      child: GestureDetector(
                        onTap: () {},
                        child: Column(
                          children: [
                            Image.asset(
                              "assets/images/iit.png",
                              width: 216,
                              height: 166,
                              fit: BoxFit.contain,
                            ),
                            const Text(
                              "Indian Institute of Technology (IITs)",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget get buildSkillsSection {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Skills",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 20),
        ...List.generate(10, (index) {
          return Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 3,
                    ),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xff4DBAF1),
                    ),
                    child: Text(
                      "${index + 1}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Programming Languages",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff3183ED)),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Proficiency in one or more programming languages, such as Python, Java, C++ or JavaScript.",
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          );
        }),
        Align(
          alignment: Alignment.center,
          child: SizedBox(
              width: 200,
              height: 51,
              child: RoundedButton(
                title: "More Skills",
                onTap: () {},
              )),
        ),
      ],
    );
  }

  Widget get buildCoursesSection {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Courses",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ...List.generate(10, (index) {
                return Row(
                  children: [
                    Container(
                      width: 245,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Color(0xffF2F8FE),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          SvgPicture.asset(
                            "assets/images/prog_lang.svg",
                            width: 50,
                            height: 50,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Programming Languages",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            "Learn programming languages like Python, Java, C++ or JavaScript.",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                              width: 160,
                              height: 41,
                              child: RoundedButton(
                                  title: "Enroll Now", onTap: () {})),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                  ],
                );
              })
            ],
          ),
        ),
      ],
    );
  }

  Widget get buildShareCard {
    return Container(
      height: 150,
      padding: const EdgeInsets.only(
        top: 10,
        left: 5,
        right: 5,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color(0xffA6E9FB),
            Color(0xffA6DBFB),
            Color(0xffA6D6FB),
          ],
        ),
      ),
      child: InkWell(
        onTap: () {
          shareOnWhatsApp(
              "I have Referred You to join Pursue! \n https://pursueit.in/");
        },
        child: Stack(
          children: [
            SvgPicture.asset(
              "assets/images/share_card_foreground.svg",
              fit: BoxFit.contain,
            ),
            const Text(
              "Tell your friends & empower them to start their careers!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            Positioned(
              bottom: -30,
              left: -40,
              right: 10,
              child: SvgPicture.asset(
                "assets/images/share_card_people_grp.svg",
                width: 180,
                height: 120,
                fit: BoxFit.contain,
              ),
            ),
            Positioned(
              bottom: 40,
              right: 10,
              child: InkWell(
                onTap: () {},
                child: SvgPicture.asset(
                  "assets/images/whatsapp.svg",
                  width: 30,
                  height: 30,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void shareOnWhatsApp(String message) async {
    final Uri url = Uri.parse('whatsapp://send?text=$message');

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
