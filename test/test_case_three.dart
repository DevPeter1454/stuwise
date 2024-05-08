import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:stuwise/core/service/firebase_auth_service.dart';
import 'package:stuwise/mock.dart';

class MockFirebaseAuthService extends Mock implements FirebaseAuthService {}

class MockBuildContext extends Mock implements BuildContext {}


void main() {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });
  group('Authentication Error Handling', () {
    testWidgets('Invalid login attempt', (WidgetTester tester) async {
      // Mocking FirebaseAuthService
      final MockFirebaseAuthService mockAuthService = MockFirebaseAuthService();

      final BuildContext context = MockBuildContext();

      // Stubbing the signInWithEmailAndPassword method to throw an error
      when(mockAuthService.signInWithEmailAndPassword(
              email: 'invalidemail', password: '123456', context: context))
          .thenThrow(FirebaseAuthException(code: 'invalid-email'));

    });
  });
}
