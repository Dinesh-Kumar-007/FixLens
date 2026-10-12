import 'package:flutter_test/flutter_test.dart';
import 'package:fixlens/main.dart';

void main() {
  testWidgets('FixLens opens the sign-in screen', (tester) async {
    await tester.pumpWidget(const FixLensApp());
    expect(find.text('Welcome back'), findsOneWidget);
  });
}