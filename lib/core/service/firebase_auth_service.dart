// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:stuwise/core/service/firebase_firestore_service.dart';
import 'package:toastification/toastification.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  FirebaseAuth get instance => _firebaseAuth;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get currentStream => _firebaseAuth.authStateChanges();

  Future<void> signOut({required BuildContext context}) async {
    await _firebaseAuth.signOut();
    toastification.show(
      context: context,
      type: ToastificationType.success,
      icon: const Icon(Icons.error),
      style: ToastificationStyle.flatColored,
      title: const Text("User logged out successfully"),
      autoCloseDuration: const Duration(seconds: 3),
    );
  }

  Future<void> signInWithEmailAndPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      final result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      if (result.user!.uid.isNotEmpty) {
        toastification.show(
          context: context,
          type: ToastificationType.success,
          icon: const Icon(Icons.error),
          style: ToastificationStyle.flatColored,
          title: const Text("User logged in successfully"),
          autoCloseDuration: const Duration(seconds: 3),
        );
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          toastification.show(
            context: context,
            type: ToastificationType.error,
            icon: const Icon(Icons.error),
            style: ToastificationStyle.flatColored,
            title: const Text("No user found for that email."),
            autoCloseDuration: const Duration(seconds: 3),
          );

          break;

        case 'wrong-password':
          toastification.show(
            context: context,
            type: ToastificationType.error,
            icon: const Icon(Icons.error),
            style: ToastificationStyle.flatColored,
            title: const Text("Wrong password provided for that user."),
            autoCloseDuration: const Duration(seconds: 3),
          );
          break;

        default:
          toastification.show(
            context: context,
            type: ToastificationType.error,
            icon: const Icon(Icons.error),
            style: ToastificationStyle.flatColored,
            title: Text(e.message.toString()),
            autoCloseDuration: const Duration(seconds: 3),
          );
      }
    }
  }

  Future<dynamic> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      final result = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return result;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          toastification.show(
            context: context,
            type: ToastificationType.error,
            icon: const Icon(Icons.error),
            style: ToastificationStyle.flatColored,
            title: const Text("The account already exists for that email."),
            autoCloseDuration: const Duration(seconds: 3),
          );

          break;
        case 'weak-password':
          toastification.show(
            context: context,
            type: ToastificationType.error,
            icon: const Icon(Icons.error),
            style: ToastificationStyle.flatColored,
            title: const Text("The password provided is too weak."),
            autoCloseDuration: const Duration(seconds: 3),
          );

          break;
        default:
          toastification.show(
            context: context,
            type: ToastificationType.error,
            icon: const Icon(Icons.error),
            style: ToastificationStyle.flatColored,
            title: Text(e.toString()),
            autoCloseDuration: const Duration(seconds: 3),
          );
      }
    }
  }
}
