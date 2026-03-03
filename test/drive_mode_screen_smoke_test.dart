import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:offroad_vehicle_monitoring/screens/drive_mode_screen.dart';

void main() {
  testWidgets('DriveModeScreen renders', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: DriveModeScreen(),
      ),
    );

    expect(find.text('IoT Flutter Lab 1'), findsOneWidget);
    expect(find.text('Apply'), findsOneWidget);
    expect(find.byType(TextFormField), findsOneWidget);
  });
}

