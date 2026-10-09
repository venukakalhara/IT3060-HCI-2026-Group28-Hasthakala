import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hasthakala/core/theme/app_theme.dart';
import 'package:hasthakala/core/shared_models/user_model.dart';
import 'package:hasthakala/features/account/presentation/screens/buyer_profile_screen.dart';
import 'package:hasthakala/features/account/presentation/screens/buyer_account_details_screen.dart';

void main() {
  final user = UserModel(
      uid: 'buyer-test', email: 'sunil@gmail.com', displayName: 'Sunil Gamage');

  testWidgets('Small buyer profile scrolls without covering sign out',
      (tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    var signedOut = false;
    await tester.pumpWidget(MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body:
              BuyerProfileScreen(user: user, onSignOut: () => signedOut = true),
          bottomNavigationBar:
              NavigationBar(selectedIndex: 3, destinations: const [
            NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
            NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
            NavigationDestination(icon: Icon(Icons.receipt), label: 'Orders'),
            NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
          ]),
        )));
    expect(find.text('Sunil Gamage'), findsOneWidget);
    expect(find.text('Edit profile'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Sign out'), 300);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(tester.getBottomLeft(find.text('Sign out')).dy,
        lessThan(tester.getTopLeft(find.byType(NavigationBar)).dy));
    await tester.tap(find.text('Sign out'));
    expect(signedOut, isTrue);
  });

  testWidgets('Edit profile opens and validates name without a network write',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
        theme: AppTheme.lightTheme,
        home: BuyerProfileScreen(user: user, onSignOut: () {})));
    await tester.tap(find.text('Edit profile'));
    await tester.pumpAndSettle();
    expect(find.byType(BuyerAccountDetailsScreen), findsOneWidget);
    await tester.enterText(find.byType(TextFormField).first, '');
    await tester.scrollUntilVisible(find.text('Save changes'), 200,
        scrollable: find.byType(Scrollable).first);
    await tester.tap(find.text('Save changes'));
    await tester.pumpAndSettle();
    expect(find.text('This field is required'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Delivery address requires all fields', (tester) async {
    await tester.pumpWidget(MaterialApp(
        theme: AppTheme.lightTheme,
        home: BuyerAccountDetailsScreen(user: user, address: true)));
    await tester.scrollUntilVisible(find.text('Save changes'), 200,
        scrollable: find.byType(Scrollable).first);
    await tester.tap(find.text('Save changes'));
    await tester.pumpAndSettle();
    expect(find.text('This field is required'), findsWidgets);
    expect(tester.takeException(), isNull);
  });
}
