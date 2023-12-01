import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_belanjakan/main.dart';
import 'package:project_belanjakan/model/user.dart';
import 'package:project_belanjakan/view/landing/register_page.dart';
import 'package:project_belanjakan/services/api/auth_client.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void main() {
  final TestWidgetsFlutterBinding binding =
      TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() => HttpOverrides.global = null);

  testWidgets('register success', (WidgetTester tester) async {
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
                child: const Registerview(),
              ),
            );
          },
        ),
      ),
    );

    await tester.enterText(
        find.byKey(const Key('register-input-username')), 'Nakula');
    await tester.enterText(
        find.byKey(const Key('register-input-email')), 'Nakula@gla.lah');
    await tester.enterText(
        find.byKey(const Key('register-input-password')), 'Nakula123@');
    await tester.enterText(
        find.byKey(const Key('register-input-number')), '081802824805');
    await tester.tap(find.byKey(const Key('register-input-date')));
    await tester.tap(find.byTooltip('Switch to input'));
    // tester.pump(const Duration(seconds: 4));

    tester.pumpAndSettle();
    // expect(find.byKey(const Key('register-message-success')), findsOneWidget);
  });
}
