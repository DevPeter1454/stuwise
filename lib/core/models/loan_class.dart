import 'package:stuwise/core/models/loan_result.dart';
import 'package:stuwise/core/models/payment_model.dart';
import 'dart:math' as math;
import 'dart:convert';


class Loan {
  double principal;
  double interestRate;
  int termInMonths;
  String currency;

  Loan(
      {required this.principal,
      required this.interestRate,
      required this.termInMonths, required this.currency});
 

  double calculateMonthlyPayment() {
    if (interestRate == 0) {
      // Handle interest-free loan scenario
      return principal / termInMonths;
    } else {
      double monthlyInterestRate = interestRate / 12;
      int totalPayments = termInMonths;
      return principal *
          (monthlyInterestRate *
              math.pow(1 + monthlyInterestRate, totalPayments)) /
          (math.pow(1 + monthlyInterestRate, totalPayments) - 1);
    }
  }

  LoanResult generateAmortizationSchedule() {
    List<Payment> schedule = [];
    double monthlyPayment = calculateMonthlyPayment();
    double balance = principal;
    double totalInterestPaid = 0.0;

    for (int month = 1; month <= termInMonths; month++) {
      double interestPayment = balance * (interestRate / 12);
      double availablePayment = monthlyPayment - interestPayment;
      double principalPayment = availablePayment;

      if (availablePayment > principal) {
        principalPayment = principal;
      }

      totalInterestPaid += interestPayment;
      balance -= principalPayment;

      if (principal <= 0) {
        break;
      }

      schedule.add(Payment(month, principalPayment, interestPayment, balance));
    }

    return LoanResult(this, schedule, totalInterestPaid, currency);
  }

   // Method to serialize Loan object to JSON
  String toJson() {
    Map<String, dynamic> jsonMap = {
      'principal': principal,
      'interestRate': interestRate,
      'termInMonths': termInMonths,
      'currency': currency
    };
    return json.encode(jsonMap);
  }

  // Method to serialize Loan object to Map
  Map<String, dynamic> toMap() {
    return {
      'principal': principal,
      'interestRate': interestRate,
      'termInMonths': termInMonths,
      'currency': currency
    };
  }

  // Factory method to deserialize JSON string to Loan object
  factory Loan.fromJson(String jsonString) {
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    return Loan(
        principal: jsonMap['principal'],
        interestRate: jsonMap['interestRate'],
        termInMonths: jsonMap['termInMonths'],
        currency: jsonMap['currency']);
  }

  // Factory method to deserialize Map to Loan object
  factory Loan.fromMap(Map<String, dynamic> map) {
    return Loan(
        principal: map['principal'],
        interestRate: map['interestRate'],
        termInMonths: map['termInMonths'],
        currency: map['currency'] ?? '\$');
  }
}
