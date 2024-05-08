// FILEPATH: /C:/Users/HP/Desktop/stuwise/test/ui/views/avalanche_view_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:stuwise/ui/views/avalanche_view.dart';
import 'package:stuwise/core/models/loan_result.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('AvalancheView can be created', (WidgetTester tester) async {
    // Prepare a dummy list of LoanResult
    List<LoanResult> dummyLoanResults = [];

    // Create the AvalancheView widget
    AvalancheView avalancheView = AvalancheView(loanResult: dummyLoanResults);

    // Add the widget to the widget tester
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: avalancheView,
      ),
    ));

    // Create a Finder for the AvalancheView widget
    Finder avalancheViewFinder = find.byType(AvalancheView);

    // Use the `findsOneWidget` matcher provided by flutter_test to verify that
    // exactly one widget with type AvalancheView is in the widget tree.
    expect(avalancheViewFinder, findsOneWidget);
  });
}