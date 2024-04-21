// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stuwise/core/models/loan_class.dart';
import 'package:stuwise/core/service/firebase_auth_service.dart';
import 'package:toastification/toastification.dart';
import 'package:flutter/material.dart';

class FirebaseFireStoreService {
  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();

  User? get currentUser => _firebaseAuthService.currentUser;

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  FirebaseFirestore get firestoreInstance => _firebaseFirestore;

  Future<void> createNewUser({
    required String email,
    required String displayName,
    required BuildContext context,
  }) async {
    try {
      final user = <String, String>{
        'email': email,
        'displayName': displayName,
        'uid': currentUser!.uid,
      };
      final result = await _firebaseFirestore.collection('users').add(user);
      if (result.id.isNotEmpty) {
        toastification.show(
          context: context,
          type: ToastificationType.success,
          icon: const Icon(Icons.error),
          style: ToastificationStyle.flatColored,
          title: const Text("User created successfully"),
          autoCloseDuration: const Duration(seconds: 3),
        );
      }
    } on FirebaseException catch (e) {
      toastification.show(
        context: context,
        type: ToastificationType.error,
        icon: const Icon(Icons.error),
        style: ToastificationStyle.flatColored,
        title: Text(e.message!),
        autoCloseDuration: const Duration(seconds: 3),
      );
    }
  }

  Future<dynamic> getUserDetails(BuildContext context) async {
    try {
      final documentSnapshot =
          await _firebaseFirestore.collection('users').get();

      return documentSnapshot.docs
          .where((element) => element.data()["uid"] == currentUser!.uid)
          .first
          .data();
    } on FirebaseException catch (e) {
      toastification.show(
        context: context,
        type: ToastificationType.error,
        icon: const Icon(Icons.error),
        style: ToastificationStyle.flatColored,
        title: Text(e.message!),
        autoCloseDuration: const Duration(seconds: 3),
      );
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getUserLoanList() {
    return _firebaseFirestore
        .collection("users")
        .doc(currentUser!.uid)
        .collection("loans")
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<dynamic> saveNewLoan(
      Loan loan, BuildContext context, String name) async {
    try {
      final loanDetails = <String, dynamic>{
        "ownerId": currentUser!.uid,
        "loanName": name,
        "loanPrincipal": loan.principal,
        "loanInterestRate": loan.interestRate,
        "loanTermInMonths": loan.termInMonths,
        "currency": loan.currency,
        "paymentSchedule":
            loan.generateAmortizationSchedule().toMap()["schedule"],
        "totalInterestPaid":
            loan.generateAmortizationSchedule().toMap()["totalInterestPaid"],
        "createdAt": FieldValue.serverTimestamp(),
      };
      final result = await _firebaseFirestore
          .collection("users")
          .doc(currentUser!.uid)
          .collection("loans")
          .add(loanDetails);
      if (result.id.isNotEmpty) {
        toastification.show(
          context: context,
          type: ToastificationType.success,
          icon: const Icon(Icons.error),
          style: ToastificationStyle.flatColored,
          title: const Text("Loan details saved successfully"),
          autoCloseDuration: const Duration(seconds: 3),
        );
      }
      return result.id;
    } on FirebaseException catch (e) {
      toastification.show(
        context: context,
        type: ToastificationType.error,
        icon: const Icon(Icons.error),
        style: ToastificationStyle.flatColored,
        title: Text(e.message!),
        autoCloseDuration: const Duration(seconds: 3),
      );
    }
  }

  Future deleteSingleLoanItem(BuildContext context, String loanId) async {
    try {
      _firebaseFirestore
          .collection("users")
          .doc(currentUser!.uid)
          .collection("loans")
          .doc(loanId)
          .delete()
          .whenComplete(() {
        toastification.show(
            context: context,
            type: ToastificationType.success,
            icon: const Icon(Icons.error),
            style: ToastificationStyle.flatColored,
            title: const Text("Loan deleted successfully"),
            autoCloseDuration: const Duration(seconds: 3));
      });
    } on FirebaseException catch (e) {
      toastification.show(
        context: context,
        type: ToastificationType.error,
        icon: const Icon(Icons.error),
        style: ToastificationStyle.flatColored,
        title: Text(e.message!),
        autoCloseDuration: const Duration(seconds: 3),
      );
    }
  }
}
