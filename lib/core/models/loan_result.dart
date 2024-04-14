import 'package:stuwise/core/models/loan_class.dart';
import 'package:stuwise/core/models/payment_model.dart';
import 'dart:convert';

class LoanResult {
  Loan loan;
  List<Payment> schedule;
  double totalInterestPaid;
  String currency;

  LoanResult(this.loan, this.schedule, this.totalInterestPaid, this.currency);

  // Method to serialize LoanResult object to JSON
  String toJson() {
    List<Map<String, dynamic>> scheduleJsonList =
        schedule.map((payment) => payment.toMap()).toList();
    Map<String, dynamic> jsonMap = {
      'loan': loan.toJson(),
      'schedule': scheduleJsonList,
      'totalInterestPaid': totalInterestPaid,
      'currency': currency,
    };
    return json.encode(jsonMap);
  }

  // Method to serialize LoanResult object to Map
  Map<String, dynamic> toMap() {
    List<Map<String, dynamic>> scheduleMapList =
        schedule.map((payment) => payment.toMap()).toList();
    return {
      'loan': loan.toMap(),
      'schedule': scheduleMapList,
      'totalInterestPaid': totalInterestPaid,
      'currency': currency,
    };
  }

  // Factory method to deserialize JSON string to LoanResult object
  factory LoanResult.fromJson(String jsonString) {
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    List<dynamic> scheduleJsonList = jsonMap['schedule'];
    List<Payment> schedule =
        scheduleJsonList.map((json) => Payment.fromMap(json)).toList();
    return LoanResult(
      Loan.fromJson(jsonMap['loan']),
      schedule,
      jsonMap['totalInterestPaid'],
      jsonMap['currency'],
    );
  }

  // Factory method to deserialize Map to LoanResult object
  factory LoanResult.fromMap(Map<String, dynamic> map) {
    List<dynamic> scheduleMapList = map['schedule'];
    List<Payment> schedule =
        scheduleMapList.map((json) => Payment.fromMap(json)).toList();
    return LoanResult(
      Loan.fromMap(map['loan']),
      schedule,
      map['totalInterestPaid'],
      map['currency'],
    );
  }
}
