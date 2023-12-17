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

  testWidgets('register Failed', (WidgetTester tester) async {
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
        find.byKey(const Key('register-input-username')), 'Invalid');
    await tester.enterText(
        find.byKey(const Key('register-input-email')), 'Nakula@gla.lah');
    await tester.enterText(
        find.byKey(const Key('register-input-password')), 'Invalid12@');
    await tester.enterText(
        find.byKey(const Key('register-input-number')), '081802824805');
    await tester.tap(find.byKey(const Key('register-input-date')));

    await tester.pump(const Duration(seconds: 2));
    await tester.tapAt(const Offset(320.0, 211.1));

    await tester.pump(const Duration(seconds: 2));
    await tester.dragFrom(
        const Offset(394.4, 277.2), const Offset(397.2, 429.9));

    await tester.pump(const Duration(seconds: 2));
    await tester.tapAt(const Offset(498.9, 477.2));

    await tester.pump(const Duration(seconds: 2));
    await tester.tapAt(const Offset(533.3, 460.5));

    await tester.pump(const Duration(seconds: 2));
    await tester.tapAt(const Offset(523.3, 550.5));

    await tester.pump();

    await tester.tap(find.byKey(const Key('register-submit')));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ElevatedButton, 'Iya'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('register-message-failed')), findsOneWidget);
  });

  testWidgets('register Success', (WidgetTester tester) async {
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
        find.byKey(const Key('register-input-email')), 'Nakula@gmail.com');
    await tester.enterText(
        find.byKey(const Key('register-input-password')), 'Nakula123@');
    await tester.enterText(
        find.byKey(const Key('register-input-number')), '081802824805');
    await tester.tap(find.byKey(const Key('register-input-date')));

    await tester.pump(const Duration(seconds: 2));
    await tester.tapAt(const Offset(320.0, 211.1));

    await tester.pump(const Duration(seconds: 2));
    await tester.dragFrom(
        const Offset(394.4, 277.2), const Offset(397.2, 429.9));

    await tester.pump(const Duration(seconds: 2));
    await tester.tapAt(const Offset(498.9, 477.2));

    await tester.pump(const Duration(seconds: 2));
    await tester.tapAt(const Offset(533.3, 460.5));

    await tester.pump(const Duration(seconds: 2));
    await tester.tapAt(const Offset(523.3, 550.5));

    await tester.pump();

    expect(find.byType(Registerview), findsWidgets);

    await tester.tap(find.byKey(const Key('register-submit')));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ElevatedButton, 'Iya'));
    await tester.pumpAndSettle();
    expect(find.byType(Registerview), findsNothing);
  });
}
