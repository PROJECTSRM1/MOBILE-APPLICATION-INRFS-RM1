import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inrfs/main.dart';

void main() {
  testWidgets('INRFS app launches', (WidgetTester tester) async {
    await tester.pumpWidget(const INRFSApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
