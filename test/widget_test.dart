import 'package:flutter_test/flutter_test.dart';
import 'package:kid_english/main.dart';

void main() {
  testWidgets('App should start', (WidgetTester tester) async {
    await tester.pumpWidget(const KidEnglishApp());
    await tester.pump();
    expect(find.text('KidEnglish'), findsOneWidget);
  });
}
