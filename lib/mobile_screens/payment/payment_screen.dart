import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:hypersdkflutter/hypersdkflutter.dart';
import 'package:pursue/mobile_screens/chat/chat_screen1.dart';
import 'package:pursue/mobile_screens/payment/failedScreen.dart';
import 'package:pursue/mobile_screens/payment/payment_details.dart';
import 'package:pursue/mobile_screens/payment/successScreen.dart';
import 'package:pursue/mobile_screens/shopping/career_result.dart';

class PaymentScreen extends StatefulWidget {
  final HyperSDK hyperSDK;
  final String amount;
  PaymentScreen({super.key,required this.hyperSDK, required this.amount });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState(amount);
}

class _PaymentScreenState extends State<PaymentScreen> {

  var showLoader = true;
  var processCalled = false;
  var paymentSuccess = false;
  var paymentFailed = false;
  var amount = "0";
  var orderId = "";
  var customerID = "";
  bool isUserPaid = false;

  List<String> resTappedOptions = tappedOptions;
  
  _PaymentScreenState(amount) {
    this.amount = amount;
  }

  Future<void> savePaymentDetails() async {
    var paymentDetails = PaymentDetails(
      userName: userName, 
      customerID: customerID, 
      orderID: orderId, 
      userEmail: userEmail, 
      timestamp: DateTime.now(),
      tappedOptions: resTappedOptions,
      careerSuggesed: careerSuggesed,
      isUserPaid: isUserPaid
    );

    try {
      await FirebaseFirestore.instance
          .collection('payment_details')
          .add(paymentDetails.toMap());
          print("user name: $userName \n"  "user email: $userEmail \n" "customerID: $customerID \n" "orderID: $orderId \n" "time stamp: ${DateTime.now} \n" "tapped Options: $resTappedOptions");
    } catch (e) {
      print("Error saving payment details: $e");
    }
  }


   void callProcess(amount) async {
    processCalled = true;
    var processPayload = await makeApiCall(amount, userEmail);

    await widget.hyperSDK.process(processPayload, hyperSDKCallbackHandler);
    // block:end:process-sdk
  }

  // Define handler for callbacks from hyperSDK
  // block:start:callback-handler
  void hyperSDKCallbackHandler(MethodCall methodCall) {
    switch (methodCall.method) {
      case "hide_loader":
        setState(() {
          showLoader = false;
        });
        break;
      case "process_result":
        var args = {};

        try {
          args = json.decode(methodCall.arguments);
        } catch (e) {
          print(e);
        }

        var error = args["error"] ?? false;

        var innerPayload = args["payload"] ?? {};

        var status = innerPayload["status"] ?? " ";
        var pi = innerPayload["paymentInstrument"] ?? " ";
        var pig = innerPayload["paymentInstrumentGroup"] ?? " ";

        if (!error) {
          switch (status) {
            case "charged":
              {
                // block:start:check-order-status
                // Successful Transaction
                // check order status via S2S API
                // block:end:check-order-status
                setState(() {
                  isUserPaid = true;
                });
                savePaymentDetails();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SuccessScreen()));
              }
              break;
            case "cod_initiated":
              {
                // User opted for cash on delivery option displayed on the Hypercheckout screen
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SuccessScreen()));
              }
              break;
          }
        } else {
          var errorCode = args["errorCode"] ?? " ";
          var errorMessage = args["errorMessage"] ?? " ";

          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const FailedScreen()));
          });
          switch (status) {
            case "backpressed":
              {
                // user back-pressed from PP without initiating any txn
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FailedScreen()));
              }
              break;
            case "user_aborted":
              {
                // user initiated a txn and pressed back
                // check order status via S2S API
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FailedScreen()));
              }
              break;
            case "pending_vbv":
              {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FailedScreen()));
              }
              break;
            case "authorizing":
              {
                // txn in pending state
                // check order status via S2S API
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FailedScreen()));
              }
              break;
            case "authorization_failed":
              {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FailedScreen()));
              }
              break;
            case "authentication_failed":
              {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FailedScreen()));
              }
              break;
            case "api_failure":
              {
                // txn failed
                // check order status via S2S API
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FailedScreen()));
              }
              break;
            case "new":
              {
                // order created but txn failed
                // check order status via S2S API
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FailedScreen()));
              }
              break;
            default:
              {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FailedScreen()));
              }
          }
        }
    }
  }

Future<Map<String, dynamic>> makeApiCall(String amount, String userEmail) async {
  var url = Uri.parse('https://api.juspay.in/session');

  var username = '64E7E748D4844698D633E0CA892934';
  var password = '';
  var basicAuth = 'Basic ' + base64Encode(utf8.encode('$username:$password'));

  var headers = {
    'Authorization': basicAuth,
    'x-merchantid': 'pursue',
    'Content-Type': 'application/json',
  };

  var rng = Random();
  var number = rng.nextInt(900000) + 100000;
  customerID = "${number}p";
  orderId = "p$number";

  var requestBody = {
    "order_id": orderId,
    "amount": amount,
    "customer_id": customerID,
    "customer_email": userEmail,
    "customer_phone": userEmail,
    "payment_page_client_id": "pursue",
    "action": "paymentPage",
    "description": "Complete your payment",
    "first_name": userName,
    "last_name": ""
  };

  var response =
      await http.post(url, headers: headers, body: jsonEncode(requestBody));

  if (response.statusCode == 200) {
    Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    return jsonResponse['sdk_payload'];
  } else {
    throw Exception('API call failed with status code ${response.statusCode}');
  }
}

  @override
  Widget build(BuildContext context) {
    if (!processCalled) {
      callProcess(amount);
    }
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          if (Platform.isAndroid) {
            var backpressResult = await widget.hyperSDK.onBackPress();
    
            if (backpressResult.toLowerCase() == "true") {
              return false;
            } else {
              return true;
            }
          } else {
            return true;
          }
        },
        // block:end:onBackPressed
        child: Container(
          color: Colors.white,
          child: Center(
            child: showLoader ? const CircularProgressIndicator() : Container(),
          ),
        ),
      ),
    );
  }
}
