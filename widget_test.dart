
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../lib/main.dart';

void main() {
  testWidgets('app displays LingoQuest home', (tester) async {
    // ignore: invalid_use_of_visible_for_testing_member
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const LingoQuestApp());
    await tester.pumpAndSettle();

    expect(find.text('LINGOQUEST'), findsOneWidget);
    expect(find.text('Sua aventura começa aqui!'), findsOneWidget);
  });
}
