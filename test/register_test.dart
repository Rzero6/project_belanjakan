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
  // test('register success', () async {
  //   User user = User(
  //       name: 'Test',
  //       password: 'TestPasword',
  //       email: 'test@gmail.com',
  //       phone: '0812312512',
  //       dateOfBirth: DateTime.now().toIso8601String());
  //   final hasil = await AuthClient.registerTesting(user);
  //   expect(hasil, equals('Register Success'));
  // });

  // test('register failed', () async {
  //   User user = User(
  //       name: 'Test',
  //       password: 'TestPasword',
  //       email: 'test@gmail.com',
  //       phone: '0812312512',
  //       dateOfBirth: DateTime.now().toIso8601String());
  //   final hasil = await AuthClient.registerTesting(user);
  //   expect(hasil, 'The email has already been taken.');
  // });

  testWidgets('register success', (WidgetTester tester) async {
    await tester.pumpWidget(
      ResponsiveSizer(
        builder: (context, orientation, deviceType) {
          final double containerHeight =
              Device.orientation == Orientation.portrait ? 20.5.h : 12.5.h;

          return MaterialApp(
            home: Container(
              width: 100.w,
              height: containerHeight,
              child: ProviderScope(child: Registerview()),
            ),
          );
        },
      ),
    );

    await tester.enterText(find.byKey(const Key('input-username')), 'Nakula');
    expect(find.text('Nakula'), findsOneWidget);
    tester.pump();
  });
}
