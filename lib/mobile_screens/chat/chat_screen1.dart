import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:pursue/main.dart';
import 'package:pursue/mobile_screens/payment/post_payment_screen.dart';
import 'package:pursue/mobile_screens/shopping/career_result.dart';

List<String> tappedOptions = [];
String amount = "";
String userId = '';
  String orderId = '';
  String customerId = '';
  String name = '';
  String email = '';
  int phoneNumber = 0;
  bool didStartChatbot = false;
  bool isPaidUser = false;
  List<String> options = [];
  List<String> finalCareerOptions = [];

class Question {
  final String question;
  final List<String> options;
  final String section;

  Question({
    required this.question,
    required this.options,
    required this.section,
  });
}

class CareerSuggestion {
  final List<String> careerSuggestions;
  final String id;
  final List<String> parameters;

  CareerSuggestion({
    required this.careerSuggestions,
    required this.id,
    required this.parameters,
  });

  factory CareerSuggestion.fromJson(Map<String, dynamic> json) {
    return CareerSuggestion(
      careerSuggestions: List<String>.from(json['CareerSuggestions']),
      id: json['ID'],
      parameters: List<String>.from(json['Parameters']),
    );
  }
}

class ChatScreen1 extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen1> {
  final ScrollController _scrollController = ScrollController();
  List<Map<String, String>> messages = [];
  List<Map<String, String>> originalMessages = [];
  bool isNextSectionFetched = false;
  int nextSectionQuestionLength = 0;
  final TextEditingController _textController = TextEditingController();
  String section = "Basic";
  List<String> optionSelected = [];
  List<List<String>> subOptions = [];
  List<String> res = [];
  String? nextSection;
  bool showAllOptions = false;
  List<Map<String, dynamic>> paymentInfo = [];

  String selectedProfession = "";
  List<Question> questions = [];
  int currentQuestionIndex = 0;
  bool isFetchingQuestions = false;
  bool isProfessionSelected = false;
  String userId = "";

  @override
  void initState() {
    super.initState();
    print("initState");
    fetchData();
    userInfo();
  }

  void dispose() {
    // Dispose the ScrollController when not needed
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );
  }

  void getCurrentUserUid() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userId = user.uid;
      print('Current user UID: $userId');
    } else {
      print('No user currently signed in.');
    }
  }

  void printUserIds() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String uid = user.uid;
      print('Current user UID (Authentication): $uid');

      try {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('Users')
            .where('uid', isEqualTo: uid)
            .get();
        if (querySnapshot.docs.isNotEmpty) {
          for (DocumentSnapshot doc in querySnapshot.docs) {
            String documentID = doc.id;
            print(
                'Document ID of the user in Firestore Users subcollection: $documentID');
          }
        } else {
          print('User document not found in Firestore Users subcollection.');
        }
      } catch (e) {
        print('Error retrieving user document from Firestore: $e');
      }
    } else {
      print('No user currently signed in.');
    }
  }

  Future<void> fetchPaymentSettingsAndNavigate() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      DocumentSnapshot paymentSettingsSnapshot =
          await firestore.collection('settings').doc('paymentInfo').get();

      if (paymentSettingsSnapshot.exists) {
        Map<String, dynamic> paymentSettings =
            paymentSettingsSnapshot.data() as Map<String, dynamic>;
        bool isPaymentOn = paymentSettings['isUpfrontPaymentOn'] ?? false;
        int paymentAmount = paymentSettings['customUpfrontPayment'] ?? 0;
        amount = paymentAmount.toString();
        print(paymentAmount);
        print(isPaymentOn);
        if (isPaymentOn) {
          await Future.delayed(const Duration(seconds: 5));
          Navigator.of(context, rootNavigator: true).pop();
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CareerResultScreen(
                hyperSDK: hyperSDK,
              ),
            ),
          );
        } else {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const PostPaymentScreen(),
            ),
          );
        }
      } else {
        print("No payment settings found.");
      }
    } catch (e) {
      print('Error fetching payment settings: $e');
    }
  }

  void _handleSubmitted(String text) {
    print("_handleSubmitted");
    print(
        "selected option list and subOptions list: $optionSelected \n $subOptions");
    _textController.clear();
    Question currentQuestion = questions[currentQuestionIndex];
    if (selectedProfession.isNotEmpty) {
      _handleProfessionSelection(selectedProfession);
    }
    _sendMessage("You", text);

    if (currentQuestion.options.isEmpty ||
        currentQuestion.options.contains(text)) {
      if (currentQuestionIndex < questions.length) {
        setState(() {
          currentQuestionIndex++;
        });
        print("next question index : $currentQuestionIndex");
        setState(() {});
        try {
          if (questions.isNotEmpty && currentQuestionIndex < questions.length) {
            displayQuestion(questions[currentQuestionIndex]);
          } else {
            print("Questions not available yet.");
          }
        } catch (e) {
          print("Section ended.................");
        }
      }
    } else {
      print("Can't select again!");
    }
  }

  void displayQuestion(Question question) {
    print("displayQuestion");
    print(
        "currentQuestionIndex inside displayQuestion function: $currentQuestionIndex");

    print(questions.length);
    print(nextSectionQuestionLength);
    print(
        "selected option list and subOptions list: $optionSelected \n $subOptions");
    String botMessage = question.question;
    _scrollToBottom();
    _sendMessage("Bot", botMessage, useAvatar: true, isOption: false);

    if (question.options.isNotEmpty) {
      _scrollToBottom();
      for (String option in question.options) {
        _sendMessage("Bot", option, isOption: true, useAvatar: false);
      }
    }
    setState(() {
      originalMessages = List.from(messages);
    });
    _scrollToBottom();
  }

  void _handleProfessionSelection(String selectedOption) {
    print("_handleProfessionSelection");
    print(
        "selected option list and subOptions list: $optionSelected \n $subOptions");
    setState(() {
      selectedProfession = selectedOption;
      fetchNextSectionQuestions(selectedOption);
    });
  }

  Future<void> fetchData() async {
    print("Fetch data");
    setState(() {
      isFetchingQuestions = true;
    });

    const apiUrl = 'http://54.160.218.173:80/admin/readQuestions';
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      print("Data from API: $data");

      if (data.containsKey("Basic")) {
        final List<dynamic> basicQuestionsData = data["Basic"];

        List<Question> fetchedQuestions = basicQuestionsData
            .map((element) => Question(
                  question: element['Question'],
                  options: List<String>.from(element['Options']),
                  section: element['Section'],
                ))
            .toList();

        if (fetchedQuestions.isNotEmpty) {
          setState(() {
            questions = fetchedQuestions;
            displayQuestion(questions[currentQuestionIndex]);
            print(
                "currentQuestionIndex inside fetchData function: $currentQuestionIndex");
          });
        } else {
          print('Error: No questions fetched for section "Basic"');
        }
      } else {
        print('Error: Section "Basic" not found in the API response');
      }
    } else {
      print('Error fetching data from the server: ${response.statusCode}');
    }

    setState(() {
      isFetchingQuestions = false;
    });
  }

  void updateSubOptions() {
    print(
        "Update subOptions called with list optionSelected list size: ${optionSelected.length}");
    if (optionSelected.length == 3) {
      print(optionSelected);
      subOptions.add([...optionSelected]);
      optionSelected.removeAt(optionSelected.length - 1);
    }
    if (nextSection == "Working Professional") {
      if (optionSelected.length == 2) {
        print(optionSelected);
        subOptions.add([...optionSelected]);
        optionSelected.removeAt(optionSelected.length - 1);
      }
    }
  }

  Future<void> fetchNextSectionQuestions(String section) async {
    print("fetchNextSectionQuestions");
    if (!isNextSectionFetched) {
      setState(() {
        isFetchingQuestions = true;
      });

      const apiUrl = 'http://54.160.218.173:80/admin/readQuestions';

      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data.containsKey(section)) {
          final List<dynamic> sectionQuestionsData = data[section];
          if (section == "Working Professional") {
            nextSection = section;
          }
          setState(() {
            questions = sectionQuestionsData
                .map((element) => Question(
                      question: element['Question'],
                      options: List<String>.from(element['Options']),
                      section: element['Section'],
                    ))
                .toList();
            currentQuestionIndex = 0;
            isNextSectionFetched = true;
            if (section.isNotEmpty) {
              nextSectionQuestionLength = questions
                  .where((question) => question.section == section)
                  .toList()
                  .length;
            }
          });
          if (questions.isNotEmpty) {
            displayQuestion(questions[currentQuestionIndex]);
            print(MediaQuery.sizeOf(context).height);
            print("Next Section question length: $nextSectionQuestionLength");
            print(
                "currentQuestionIndex inside fetchNextSection function: $currentQuestionIndex");
            print(
                "selected option list and subOptions list: $optionSelected \n $subOptions");
          }
        } else {
          print('Error: Section "$section" not found in the API response');
        }
      } else {
        print('Error fetching data from the server: ${response.statusCode}');
      }

      setState(() {
        isFetchingQuestions = false;
      });
    }
  }
  Future<void> userInfo() async {
    final response =
        await http.get(Uri.parse('https://pursueit.in:8080/admin/users'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data.containsKey('result')) {
        setState(() {
          paymentInfo = List<Map<String, dynamic>>.from(data['result']);
        });
        final userDetail = data['result'] as Map<String, dynamic>;
          userId = userDetail['UserID'] ?? '';
          orderId = userDetail['OrderID'] ?? '';
          customerId = userDetail['CustomerID'] ?? '';
          name = userDetail['Name'] ?? '';
          email = userDetail['Email'] ?? '';
          phoneNumber = userDetail['PhoneNumber'] ?? 0;
          didStartChatbot = userDetail['DidStartChatbot'] ?? false;
          isPaidUser = userDetail['IsPaidUser'] ?? false;
          options = List<String>.from(userDetail['Options'] ?? []);
          finalCareerOptions = List<String>.from(userDetail['FinalCareerOptions'] ?? []);
          print('User ID: $userId');
          print('Order ID: $orderId');
          print('Customer ID: $customerId');
          print('Name: $name');
          print('Email: $email');
          print('Phone Number: $phoneNumber');
          print('Did Start Chatbot: $didStartChatbot');
          print('Is Paid User: $isPaidUser');
          print('Options: $options');
          print('Final Career Options: $finalCareerOptions');
      }
    } else {
      throw Exception('Failed to load payment info');
    }
  }

  void _handleOptionSelected(String selectedOption) {
    if (isNextSectionFetched) {
      optionSelected.add(selectedOption);
      tappedOptions.add(selectedOption);
      updateSubOptions();
    }
    print("_handleOptionSelected");
    _checkAndNavigate();
    if (!isProfessionSelected) {
      setState(() {
        selectedProfession = selectedOption;
        isProfessionSelected = true;
      });
    }
    setState(() {
      messages.removeWhere((message) => message['isOption'] == 'true');
    });
    _handleSubmitted(selectedOption);
  }

  Future<List<CareerSuggestion>> fetchCareerSuggestions(
      List<List<String>> userSelectedOptions) async {
    var response = await http.get(
        Uri.parse('http://54.160.218.173:80/admin/readRepository/Repository'));
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      List<CareerSuggestion> careerSuggestions =
          jsonResponse.map((data) => CareerSuggestion.fromJson(data)).toList();
      List<String> matchedCareerSuggestions = [];
      for (List<String> option in userSelectedOptions) {
        for (CareerSuggestion suggestion in careerSuggestions) {
          if (ListEquality().equals(option, suggestion.parameters)) {
            matchedCareerSuggestions.addAll(suggestion.careerSuggestions);
          }
        }
      }
      print(matchedCareerSuggestions);
    } else {
      throw Exception('Failed to fetch career suggestions');
    }

    throw Exception('Failed to fetch career suggestions');
  }

  void _checkAndNavigate() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("current Question index after submission: $currentQuestionIndex");
      print("Next Section question length: $nextSectionQuestionLength");
      bool allQuestionsAnswered =
          currentQuestionIndex == nextSectionQuestionLength;

      if (selectedProfession != "Basic" && allQuestionsAnswered) {
        if (subOptions.isNotEmpty) {
          // Fetch career suggestions based on user-selected options
          fetchCareerSuggestions(subOptions).then((careerSuggestions) {
            // Handle fetched career suggestions here
            print("Fetched Career Suggestions: $careerSuggestions");
            // Add logic to store career suggestions in res list or perform any other actions
          }).catchError((error) {
            print('Error fetching career suggestions: $error');
          });
        }
        print(optionSelected);
        selectedOptions = subOptions;
        print(subOptions);
        print(tappedOptions);
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return const AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text("Please wait, while we are analyzing your data!"),
                ],
              ),
            );
          },
        );
        fetchPaymentSettingsAndNavigate();
      } else {
        print("Condition not met");
      }
    });
  }

  bool isCurrentQuestionWithOptions() {
    if (questions.isNotEmpty) {
      Question currentQuestion = questions[currentQuestionIndex];
      if (isProfessionSelected == true) return false;
      if (currentQuestion.options.isNotEmpty) {
        return false;
      }
    }
    return true;
  }

  void _sendMessage(String sender, String message,
      {bool isOption = false, bool useAvatar = false}) {
    print("_sendMessage");
    print(
        "selected option list and subOptions list: $optionSelected \n $subOptions");
    setState(() {
      if (isOption) {
        messages.add({
          "sender": sender,
          "message": message,
          "isOption": true.toString(),
        });
      } else {
        messages.add({
          "sender": sender,
          "message": message,
          "useAvatar": useAvatar.toString(),
        });
      }
    });
  }

  Widget _buildMessage(String message, bool isMe, bool isBot,
      {bool isOption = false}) {
    final alignment = isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final color = isMe ? Color(0xFF2F80ED) : const Color(0xFFEAF2FD);
    final textColor = isMe ? Colors.white : Colors.black87;

    return Column(
      crossAxisAlignment: alignment,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          margin: isMe
              ? const EdgeInsets.only(top: 8, bottom: 8, left: 80)
              : const EdgeInsets.only(top: 8, bottom: 8, right: 80),
          decoration: isMe
              ? BoxDecoration(
                  color: color,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    topLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                )
              : BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(25),
                    topLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message,
                style: TextStyle(
                    fontSize: 15, fontFamily: 'Mazzard', color: textColor),
              ),
              if (isOption) _buildOptions(message),
            ],
          ),
        ),
      ],
    );
  }

 Widget _buildOptions(String optionsString) {
  List<String> options = optionsString.split(',');
  bool shouldShowReadMore = options.length > 5;
  List<String> displayOptions = shouldShowReadMore ? options.sublist(0, 5) : options;
  bool showAllOptions = false;

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 2),
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 3),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFFBFDCFF)),
        color: Color(0xFFEAF2FD),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < displayOptions.length; i++)
            TextButton(
              onPressed: () {
                _handleOptionSelected(displayOptions[i]);
              },
              child: Center(
                child: Text(displayOptions[i],
                    style: GoogleFonts.raleway(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w500)),
              ),
            ),
          if (shouldShowReadMore)
            TextButton(
              onPressed: () {
                setState(() {
                  showAllOptions = !showAllOptions;
                });
              },
              child: Text(showAllOptions ? 'Show Less' : 'Load More'),
            ),
          if (showAllOptions)
            for (var i = 5; i < options.length; i++)
              TextButton(
                onPressed: () {
                  _handleOptionSelected(options[i]);
                },
                child: Center(
                  child: Text(options[i],
                      style: GoogleFonts.raleway(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w500)),
                ),
              ),
        ],
      ),
    ),
  );
}


  Widget _buildTypingIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      margin: const EdgeInsets.only(top: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Row(
        children: [
          SizedBox(width: 10),
          Text(
            "Typing...",
            style: TextStyle(fontSize: 17, letterSpacing: 5),
          ),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return Container(
      padding: const EdgeInsets.only(bottom: 5),
      margin: const EdgeInsets.symmetric(horizontal: 3.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.white,
            blurRadius: 10,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFECECEC),
                // border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                decoration: InputDecoration(
                  hintText: "Type a Message",
                  hintStyle: GoogleFonts.roboto(),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 10.0),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 3,
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: () {
                if (_textController.text.isNotEmpty) {
                  _handleSubmitted(_textController.text);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50.0, bottom: 70),
                child: Column(
                  children: [
                    Container(
                        height: 60,
                        width: 60,
                        child: Image(
                            image: AssetImage("assets/images/pursue.png"))),
                    const Text(
                      "Pursue",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: messages.length,
                  itemBuilder: (BuildContext context, int index) {
                    final messageData = messages[index];
                    if (messageData['isOption'] == 'true') {
                      return _buildOptions(messageData['message']!);
                    } else {
                      return _buildMessage(
                        messageData['message']!,
                        messageData['sender'] == 'You',
                        messageData['isBot'] == true && isFetchingQuestions,
                        isOption: messageData['isOption'] == 'true',
                      );
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 20),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFEAF2FD))),
                ),
              ),
              if (isFetchingQuestions) _buildTypingIndicator(),
              if (!isProfessionSelected && isCurrentQuestionWithOptions())
                _buildTextComposer(),
            ],
          ),
        ),
      ),
    );
  }
}