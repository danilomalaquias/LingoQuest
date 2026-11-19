import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lingoquest/main.dart';

void main() {
  testWidgets('app displays LingoQuest home', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const LingoQuestApp());
    await tester.pumpAndSettle();
    expect(find.text('LINGOQUEST'), findsOneWidget);
    expect(find.text('Sua aventura começa aqui!'), findsOneWidget);
  });
}
