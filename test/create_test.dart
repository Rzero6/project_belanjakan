import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_belanjakan/view/products/manage/input_page.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  final TestWidgetsFlutterBinding binding =
      TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() => HttpOverrides.global = null);

  testWidgets('create success', (WidgetTester tester) async {
    await tester.pumpWidget(
      ResponsiveSizer(
        builder: (context, orientation, deviceType) {
          final double containerHeight =
              Device.orientation == Orientation.portrait ? 20.5.h : 12.5.h;

          return MaterialApp(
            home: SizedBox(
              width: 100.w,
              height: containerHeight,
              child: const ProviderScope(child: ItemInputPage()),
            ),
          );
        },
      ),
    );

    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    await sharedPrefs.setString('token', 'userData.token!');

    await tester.enterText(find.byKey(const Key('input-name')), 'Bola Basket');
    await tester.enterText(find.byKey(const Key('input-detail')),
        'Bola Basket yang Dipakai Pemain Profesional');
    await tester.enterText(find.byKey(const Key('input-price')), '150000');
    await tester.enterText(find.byKey(const Key('input-stock')), '250');

    await tester.pump();

    await tester.pump(const Duration(seconds: 4));
    await tester.tapAt(const Offset(360.0, 201.1));
    // await tester.tap(find.text('Save'));

    await tester.pumpAndSettle();
  });
}
