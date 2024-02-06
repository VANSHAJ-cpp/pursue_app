class PaymentDetails {
  final String userName;
  final String customerID;
  final String orderID;
  final String userEmail;
  final DateTime timestamp;
  final List<String> tappedOptions;
  final List<String> careerSuggesed;
  bool isUserPaid;

  PaymentDetails({
    required this.userName,
    required this.customerID,
    required this.orderID,
    required this.userEmail,
    required this.timestamp,
    required this.tappedOptions,
    required this.careerSuggesed,
    required this.isUserPaid
  });

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'customerID': customerID,
      'orderID': orderID,
      'userEmail': userEmail,
      'timestamp': timestamp,
      'tappedOptions': tappedOptions,
      'careerSuggested': careerSuggesed,
      'isUserPaid': isUserPaid
    };
  }
}

