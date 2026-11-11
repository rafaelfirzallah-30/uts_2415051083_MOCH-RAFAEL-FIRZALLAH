import 'package:flutter_test/flutter_test.dart';
import 'package:myappsdrink/main.dart';

void main() {
  testWidgets('HydroTrack app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const HydroTrackApp());

    // Allow asynchronous timers (database & API load) to settle
    await tester.pumpAndSettle();

    // Verify that the title and target card appear
    expect(find.text('HydroTrack'), findsOneWidget);
    expect(find.text('Target Hidrasi Hari Ini'), findsOneWidget);
  });
}
