import 'package:chating_app/screens/account.dart';
import 'package:chating_app/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chating_app/main.dart';

void main() {
  testWidgets('initial is Home page', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byType(Home), findsOneWidget);
    expect(find.byType(account), findsNothing);
  });

  testWidgets('Tapping on Account navigates to Account screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.byIcon(Icons.person));
    await tester.pumpAndSettle();
    expect(find.byType(MyHomePage), findsOneWidget);
    expect(find.byType(Home), findsNothing);
    expect(find.byType(account), findsOneWidget);
  });

  testWidgets('Tapping on Messages navigates back to Home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.byIcon(Icons.person));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.messenger_sharp));
    await tester.pumpAndSettle();

    expect(find.byType(Home), findsOneWidget);
    expect(find.byType(account), findsNothing);
  });
}