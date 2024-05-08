import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:stuwise/core/service/firebase_auth_service.dart';
import 'package:stuwise/core/service/firebase_firestore_service.dart';
import 'package:stuwise/mock.dart';
import 'package:stuwise/ui/constants/exports.dart';
import 'package:stuwise/ui/views/bottom_nav_view.dart';

class MockFirebaseAuthService extends Mock implements FirebaseAuthService {}

class MockBuildContext extends Mock implements BuildContext {}

class MockFirebaseFireStoreService extends Mock
    implements FirebaseFireStoreService {}

void main() {
  group('Navigation to Key Features', () {
    setupFirebaseAuthMocks();

    setUpAll(() async {
      await Firebase.initializeApp();
    });
    testWidgets('Tap each navigation tab', (WidgetTester tester) async {
      final mockFirebaseFireStoreService = MockFirebaseFireStoreService();
      final BuildContext context = MockBuildContext();

      when(mockFirebaseFireStoreService.getUserDetails(context))
          .thenAnswer((_) async => {'displayName': 'Test User'});

     
      await tester
          .pumpWidget(Sizer(builder: (context, orientation, deviceType) {
        return const MaterialApp(
          home: BottomNavView(),
        );
      }));

      // Finding and tapping each navigation tab
      final homeTab = find.text("Home");
      final debtsTab = find.text('Debts');
      final strategyTab = find.text('Strategy');
      final learnTab = find.text('Learn');
      final profileTab = find.text('Profile');

      await tester.tap(homeTab);
      await tester.tap(debtsTab);

      await tester.tap(strategyTab);

      await tester.tap(learnTab);
      await tester.pumpAndSettle();

      await tester.tap(profileTab);
    });
  });
}
