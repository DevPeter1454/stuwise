import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stuwise/ui/constants/exports.dart';
import 'package:stuwise/ui/views/learn_view.dart';

void main() {
  group('Access Financial Education Content', () {
    testWidgets('Browse and select financial topics',
        (WidgetTester tester) async {
      await tester
          .pumpWidget(Sizer(builder: (context, orientation, deviceType) {
        return const MaterialApp(
          home: LearnView(),
        );
      }));

      
      expect(find.byType(LearnTileWidget), findsNWidgets(7));

    
      await tester.tap(find.text("Difference between good and bad credit"));
      await tester.pumpAndSettle();


      expect(
          find.text("Difference between good and bad credit"), findsOneWidget);
    });
  });
}
