import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_belanjakan/view/landing/login_page.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void main() {
  // test('login success', () async {
  //   final hasil =
  //       await AuthClient.loginTesting('test@gmail.com', 'TestPasword');
  //   expect(hasil.name, equals('Test'));
  // });

  // test('login failed', () async {
  //   final result = await AuthClient.loginTesting("email@email.com", "password");
  //   expect(result, null);
  // });

  setUpAll(() => HttpOverrides.global = null);
  testWidgets('login success', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: ResponsiveSizer(
          builder: (context, orientation, deviceType) {
            final double containerHeight =
                Device.orientation == Orientation.portrait ? 20.5.h : 12.5.h;

            return MaterialApp(
              home: SizedBox(
                width: 100.w,
                height: containerHeight,
                child: const Loginview(),
              ),
            );
          },
        ),
      ),
    );

    await tester.enterText(
        find.byKey(const Key('input-email')), 'akatsukikh99@gmail.com');
    await tester.enterText(
        find.byKey(const Key('input-password')), '12345678!');
    await tester.tap(find.byKey(const ValueKey('login')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('sakis-login')), findsOneWidget);
  });

  testWidgets('login failed', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: ResponsiveSizer(
          builder: (context, orientation, deviceType) {
            final double containerHeight =
                Device.orientation == Orientation.portrait ? 20.5.h : 12.5.h;

            return MaterialApp(
              home: SizedBox(
                width: 100.w,
                height: containerHeight,
                child: const Loginview(),
              ),
            );
          },
        ),
      ),
    );

    await tester.enterText(
        find.byKey(const Key('input-email')), 'INVALID@valid.not');
    await tester.enterText(find.byKey(const Key('input-password')), 'INVALID');
    await tester.tap(find.byKey(const ValueKey('login')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('error-login')), findsOneWidget);
  });
}
