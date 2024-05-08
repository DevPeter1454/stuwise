import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:stuwise/core/service/firebase_auth_service.dart';
import 'package:stuwise/core/service/firebase_firestore_service.dart';
import 'package:stuwise/mock.dart';
import 'package:stuwise/ui/constants/exports.dart';
import 'package:stuwise/ui/views/settings_view.dart';

class MockFirebaseAuthService extends Mock implements FirebaseAuthService {}

class MockFirebaseFirestoreService extends Mock
    implements FirebaseFireStoreService {}

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });
  group('Profile Information Display', () {
    testWidgets('Check displayed profile information',
        (WidgetTester tester) async {
      final MockFirebaseFirestoreService mockFirestoreService =
          MockFirebaseFirestoreService();
      final BuildContext context = MockBuildContext();

      // Mock user details
      final Map<String, dynamic> userDetails = {
        'displayName': 'John Doe',
        'email': 'john.doe@example.com',
      };

      // Mock getUserDetails method
      when(mockFirestoreService.getUserDetails(context))
          .thenAnswer((_) async => userDetails);

      // Building the SettingsView widget
      await tester
          .pumpWidget(Sizer(builder: (context, orientation, deviceType) {
        return const MaterialApp(
          home: SettingsView(),
        );
      }));

      find.text("John Doe");
      find.text("john.doe@example.com");
    });
  });
}
