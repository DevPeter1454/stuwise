import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:stuwise/core/service/firebase_firestore_service.dart';
import 'package:stuwise/mock.dart';
import 'package:stuwise/ui/constants/exports.dart';
import 'package:stuwise/ui/views/avalanche_view.dart';
import 'package:stuwise/ui/views/snowball_view.dart';
import 'package:stuwise/ui/views/strategy_view.dart';

class MockFirebaseFireStoreService extends Mock
    implements FirebaseFireStoreService {}

class MockQuerySnapshot extends Mock
    implements QuerySnapshot<Map<String, dynamic>> {}

class MockFirebaseUser extends Mock implements User {}

class MockFirestore extends Mock implements FirebaseFirestore {}



void main() {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  group('Select Debt Repayment Strategy', () {
    testWidgets('Choose a repayment strategy and apply to debts',
        (WidgetTester tester) async {
      final mockFirebaseFireStoreService = MockFirebaseFireStoreService();

      final mockFireStore = MockFirestore();

      final mockQuerySnapshot = MockQuerySnapshot();

      final user = MockFirebaseUser();

      final loanData1 = {
        "currency": "USD",
        "loanPrincipal": 10000,
        "loanInterestRate": 5,
        "loanTermInMonths": 60,
        "loanName": "House loan",
        "totalInterestPaid": 2500,
        'createdAt': DateTime.now()
      };

      final loanData2 = {
        "currency": "EUR",
        "loanPrincipal": 8000,
        "loanInterestRate": 4,
        "loanTermInMonths": 48,
        "loanName": "Car loan",
        "totalInterestPaid": 1500,
        'createdAt': DateTime.now()
      };

      final expectedDocs = [loanData1, loanData2];

      // Mock Firestore behavior (if needed)
      // when(mockFirebaseFireStoreService.getUserLoanList()).thenAnswer(
      //   (_) => Stream.value(expectedDocs as mockQuerySnapshot),
      // );

      
      // Mocking the stream data for user's loan list
      // when(mockFirebaseFireStoreService.getUserLoanList()).thenAnswer(
      //   (_) => Stream.value( as QuerySnapshot<Map<String, dynamic>>),
      // );

      // Building the StrategyView widget with mocked service
      await tester
          .pumpWidget(Sizer(builder: (context, orientation, deviceType) {
        return const MaterialApp(
          home: StrategyView(),
        );
      }));

      // Tap on Avalanche Strategy checkbox
      await tester.tap(find.byKey(const Key('avalanche_checkbox')));
      await tester.pumpAndSettle();

      // Tap on View Result button
      await tester.tap(find.text('View Result'));
      await tester.pumpAndSettle();

      // Verify that AvalancheView is pushed
      expect(find.byType(AvalancheView), findsOneWidget);

      // Tap on SnowBall Strategy checkbox
      await tester.tap(find.byKey(const Key('snowball_checkbox')));
      await tester.pumpAndSettle();

      // Tap on View Result button
      await tester.tap(find.text('View Result'));
      await tester.pumpAndSettle();

      // Verify that SnowBallView is pushed
      expect(find.byType(SnowBallView), findsOneWidget);
    });
  });
}
