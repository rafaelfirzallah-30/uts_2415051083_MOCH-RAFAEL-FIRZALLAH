import 'package:flutter_test/flutter_test.dart';
import 'package:myappsdrink/main.dart';

void main() {
  testWidgets('HydroTrack app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const HydroTrackApp());

    // Verify that the title appears
    expect(find.text('HydroTrack'), findsOneWidget);
    expect(find.text('Target Hari Ini'), findsOneWidget);
  });
}
