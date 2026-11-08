import 'package:flutter_test/flutter_test.dart';
import 'package:contact_cleaner/main.dart';

void main() {
  testWidgets('Contact Cleaner smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ContactCleanerApp());
    await tester.pump();
    expect(find.byType(ContactCleanerApp), findsOneWidget);
  });
}
