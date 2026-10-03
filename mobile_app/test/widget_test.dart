import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:radiocharu_app/main.dart';

void main() {
  testWidgets('RadioCharuApp mobile layout smoke test', (WidgetTester tester) async {
    // Configure mobile screen size (390 x 844)
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const RadioCharuApp());
    await tester.pump();

    // Verify station title is displayed
    expect(find.text('রেডিও চারু'), findsWidgets);
  });

  testWidgets('RadioCharuApp tablet layout test', (WidgetTester tester) async {
    // Configure tablet screen size (800 x 1024)
    tester.view.physicalSize = const Size(800, 1024);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const RadioCharuApp());
    await tester.pump();

    expect(find.text('রেডিও চারু'), findsWidgets);
  });

  testWidgets('RadioCharuApp desktop layout test', (WidgetTester tester) async {
    // Configure desktop screen size (1440 x 900)
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const RadioCharuApp());
    await tester.pump();

    expect(find.text('রেডিও চারু'), findsWidgets);
    expect(find.text('অনলাইন স্টুডিও সংযোগ'), findsOneWidget);
  });
}
