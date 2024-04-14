import 'dart:convert';

class Payment {
  int month;
  double principalPayment;
  double interestPayment;
  double remainingBalance;

  Payment(this.month, this.principalPayment, this.interestPayment,
      this.remainingBalance);

  // Method to serialize Payment object to JSON
  String toJson() {
    Map<String, dynamic> jsonMap = {
      'month': month,
      'principalPayment': principalPayment,
      'interestPayment': interestPayment,
      'remainingBalance': remainingBalance,
    };
    return json.encode(jsonMap);
  }

  // Method to serialize Payment object to Map
  Map<String, dynamic> toMap() {
    return {
      'month': month,
      'principalPayment': principalPayment,
      'interestPayment': interestPayment,
      'remainingBalance': remainingBalance,
    };
  }

  // Factory method to deserialize JSON string to Payment object
  factory Payment.fromJson(String jsonString) {
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    return Payment(
      jsonMap['month'],
      jsonMap['principalPayment'],
      jsonMap['interestPayment'],
      jsonMap['remainingBalance'],
    );
  }

  // Factory method to deserialize Map to Payment object
  factory Payment.fromMap(Map<String, dynamic> map) {
    return Payment(
      map['month'],
      map['principalPayment'],
      map['interestPayment'],
      map['remainingBalance'],
    );
  }
}
