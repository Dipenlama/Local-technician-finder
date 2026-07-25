import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mistrix/features/home/presentation/pages/tabs/profile_tab.dart';

void main() {
  testWidgets('profile opens help and about pages', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ProfileTab(
            userName: 'Test Client',
            userEmail: 'client@mistrix.app',
            userPhone: '9800000000',
            onEditPersonalInformation: () {},
            onFavoriteTechnicians: () {},
            onLogout: () {},
          ),
        ),
      ),
    );

    await tester.tap(find.text('Help and support'));
    await tester.pumpAndSettle();
    expect(find.text('How can we help?'), findsOneWidget);
    expect(find.text('Frequently asked questions'), findsOneWidget);
    await tester.drag(
      find.byType(ListView).last,
      const Offset(0, -900),
    );
    await tester.pumpAndSettle();
    expect(find.text('support@mistrix.app'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.text('About Mistrix'));
    await tester.pumpAndSettle();
    expect(find.text('Our mission'), findsOneWidget);
    expect(find.text('Why choose Mistrix?'), findsOneWidget);
    await tester.drag(
      find.byType(ListView).last,
      const Offset(0, -900),
    );
    await tester.pumpAndSettle();
    expect(find.text('App version'), findsOneWidget);
  });
}
