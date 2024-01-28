// ignore_for_file: prefer_const_constructors, no_logic_in_create_state, prefer_initializing_formals

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hypersdkflutter/hypersdkflutter.dart';
import 'package:http/http.dart' as http;
import 'package:pursue/mobile_screens/payment/failedScreen.dart';
import 'package:pursue/mobile_screens/payment/successScreen.dart';

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
  
  _PaymentScreenState(amount) {
    this.amount = amount;
  }

   void callProcess(amount) async {
    processCalled = true;
    var processPayload = await makeApiCall(amount);
    // Get process payload from backend
    // block:start:fetch-process-payload
    // var processPayload = await getProcessPayload(widget.amount);
    // block:end:fetch-process-payload

    // Calling process on hyperSDK to open the Hypercheckout screen
    // block:start:process-sdk
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

          // WidgetsBinding.instance.addPostFrameCallback((_) {
          //   Navigator.pushReplacement(context,
          //       MaterialPageRoute(builder: (context) => const SuccessScreen()));
          // });
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

  Future<Map<String, dynamic>> makeApiCall(amount) async {
  var url = Uri.parse('https://api.juspay.in/session');


  // API Key Should never be used from client side, it should always be stored securely on server.
  // And all the API calls requiring API key should always be done from server
  var headers = {
    'Authorization': 'Basic 64E7E748D4844698D633E0CA892934',
    'x-merchantid': 'pursue',
    'Content-Type': 'application/json',
  };

  var rng = Random();
  var number = rng.nextInt(900000) + 100000;

  var requestBody = {
    "order_id": "test$number",
    "amount": amount,
    "customer_id": "9876543201",
    "customer_email": "avanishraj005@mail.com",
    "customer_phone": "9876543201",
    "payment_page_client_id": "pursue",
    "action": "paymentPage",
    "description": "Complete your payment",
    "first_name": "Avanish",
    "last_name": "Raj"
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
    return WillPopScope(
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
    );
  }
}
