import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mistrix/app.dart';
import 'package:mistrix/injection_container.dart';

void main() {
  testWidgets('shows the Mistrix onboarding page', (tester) async {
    await tester.pumpWidget(MistrixApp(dependencies: configureDependencies()));
    await tester.pumpAndSettle();

    expect(find.text('mistrix'), findsOneWidget);
    expect(find.text('Find the right expert'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
  });

  testWidgets('can sign in and open the home navigation', (tester) async {
    await tester.pumpWidget(MistrixApp(dependencies: configureDependencies()));
    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(EditableText).at(0), 'user@mistrix.app');
    await tester.enterText(find.byType(EditableText).at(1), 'password');
    await tester.tap(find.text('Sign in'));
    await tester.pumpAndSettle();

    expect(find.text('What service do you need?'), findsOneWidget);
    expect(find.text('Explore'), findsOneWidget);
    expect(find.text('Bookings'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });
}
