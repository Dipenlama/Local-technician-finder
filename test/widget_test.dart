import 'package:flutter_test/flutter_test.dart';
import 'package:mistrix/app.dart';
import 'package:mistrix/injection_container.dart';

void main() {
  testWidgets('shows the Mistrix technician finder home page', (tester) async {
    await tester.pumpWidget(MistrixApp(dependencies: configureDependencies()));
    await tester.pumpAndSettle();

    expect(find.text('Mistrix'), findsOneWidget);
    expect(find.text('Recommended technicians'), findsOneWidget);
    expect(find.text('Aarav Sharma'), findsOneWidget);
  });
}
