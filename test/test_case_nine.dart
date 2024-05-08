import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:stuwise/core/service/firebase_auth_service.dart';
import 'package:stuwise/mock.dart';
import 'package:stuwise/ui/size_utils.dart';
import 'package:stuwise/ui/views/settings_view.dart';

class MockFirebaseAuthService extends Mock implements FirebaseAuthService {}

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });
  group('Secure Log Out', () {
    testWidgets('Log out securely', (WidgetTester tester) async {
     
      final MockFirebaseAuthService mockAuthService = MockFirebaseAuthService();
      final BuildContext context = MockBuildContext();

      await tester
          .pumpWidget(Sizer(builder: (context, orientation, deviceType) {
        return const MaterialApp(
          home: SettingsView(),
        );
      }));
      when(mockAuthService.signOut(context: context)).thenAnswer((_) async {});
      find.text('Log Out');
     
    });
  });
}
