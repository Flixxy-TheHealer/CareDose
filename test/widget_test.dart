import 'package:flutter_test/flutter_test.dart';

import 'package:care_dose/main.dart';

void main() {
  testWidgets('shows the login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const CareDoseApp());

    expect(find.text('CareDose'), findsOneWidget);
    expect(find.text('Send OTP'), findsOneWidget);
    expect(find.text('Create Account'), findsOneWidget);
  });
}
