import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:stuwise/core/models/loan_class.dart';
import 'package:stuwise/core/service/firebase_firestore_service.dart';
import 'package:stuwise/mock.dart';

class MockFirebaseFireStoreService extends Mock
    implements FirebaseFireStoreService {}

class MockBuildContext extends Mock implements BuildContext {}

void main() {

  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });
  group('Add New Debt Entry', () {
    testWidgets('Enter new debt details and request repayment schedule',
        (WidgetTester tester) async {
      final mockFirebaseFireStoreService = MockFirebaseFireStoreService();
      final BuildContext context = MockBuildContext();

      final mockLoan = Loan(
        principal: 10000,
        interestRate: 5,
        termInMonths: 5,
        currency: 'USD',
      );
      // Mocking the method to save a new loan
      when(mockFirebaseFireStoreService.saveNewLoan(
              mockLoan, context, 'Test Loan'))
          .thenAnswer((_) async => true);

    });
  });
}
