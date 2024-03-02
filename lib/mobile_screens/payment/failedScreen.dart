import 'package:flutter/material.dart';
import 'package:pursue/main.dart';
import 'package:pursue/mobile_screens/chat/chat_screen1.dart';
import 'package:pursue/mobile_screens/payment/payment_screen.dart';
import 'package:pursue/mobile_screens/shopping/career_result.dart';
import 'package:google_fonts/google_fonts.dart';

class FailedScreen extends StatefulWidget {
  const FailedScreen({super.key});

  @override
  State<FailedScreen> createState() => _FailedScreenState();
}

//#EFEDF8
class _FailedScreenState extends State<FailedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEFF1F3),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(children: [
              const Padding(
                padding: EdgeInsets.only(left: 15.0, right: 15, top: 5),
                child: SizedBox(
                  height: 200,
                  width: 300,
                  child: Image(
                      image: AssetImage("assets/images/failed_screen_gif.gif"),),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20),
                child: Center(
                    child: Padding(
                  padding:const EdgeInsets.all(10.0),
                  child: Center(
                      child: Text(
                    'Oops, look like the payment failed',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.raleway(
                      fontSize: 25, fontWeight: FontWeight.w800
                    )
                  )),
                ),),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20),
                child: Center(
                    child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Center(
                      child: Text(
                    'You can retry the payment below to continue this.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.raleway(
                      color: Colors.blueGrey,
                      fontSize: 20, fontWeight: FontWeight.w500
                    )
                  )),
                )),
              ),
            ]),
            //#EF785E
            SizedBox(height: 20),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20),
                  child: Card(
                    elevation: 15,
                    color: Colors.red,
                    shadowColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (_) => PaymentScreen(
                                    hyperSDK: hyperSDK,
                                    amount: amount,
                                  )),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30)),
                        width: 100,
                        child: Center(
                            child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            "Retry",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),
                          ),
                        )),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20),
                  child: Card(
                    elevation: 15,
                    color: Colors.red,
                    shadowColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (_) =>
                                  CareerResultScreen(hyperSDK: hyperSDK)),
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(left: 40.0, right: 40),
                        child: Center(
                            child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            "Go back to the chat!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),
                          ),
                        )),
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
