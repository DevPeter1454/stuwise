import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:stuwise/core/service/firebase_auth_service.dart';
import 'package:stuwise/core/service/firebase_firestore_service.dart';
import 'package:stuwise/mock.dart';
import 'package:stuwise/ui/size_utils.dart';
import 'package:stuwise/ui/views/sign_in.dart';

class MockFirebaseAuthService extends Mock implements FirebaseAuthService {}

class MockFirebaseUser extends Mock implements User {}

class MockBuildContext extends Mock implements BuildContext {}

class MockFirebaseFirestoreService extends Mock
    implements FirebaseFireStoreService {}


void main() {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });
  group('User Login', () {
    testWidgets('Successful Login', (WidgetTester tester) async {
      final mockFirebaseAuthService = MockFirebaseAuthService();
      final user = MockFirebaseUser();
      final BuildContext context = MockBuildContext();
      when(mockFirebaseAuthService.signInWithEmailAndPassword(
              email: 'john.doe@example.com',
              password: 'test1234',
              context: context))
          .thenAnswer((_) async => user); // Change this line
    
      await tester.pumpWidget(
        Sizer(builder: (context, orientation, deviceType) {
          return const MaterialApp(
            home: SignInView(),
          );
        }),
      );
    });
  });
}
