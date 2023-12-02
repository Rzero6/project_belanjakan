import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_belanjakan/view/products/manage/input_page.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  final TestWidgetsFlutterBinding binding =
      TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() => HttpOverrides.global = null);

  testWidgets('update success', (WidgetTester tester) async {
    await tester.pumpWidget(
      ResponsiveSizer(
        builder: (context, orientation, deviceType) {
          final double containerHeight =
              Device.orientation == Orientation.portrait ? 20.5.h : 12.5.h;

          return MaterialApp(
            home: SizedBox(
              width: 100.w,
              height: containerHeight,
              child: const ProviderScope(child: ItemInputPage(id: 1)),
            ),
          );
        },
      ),
    );

    await tester.enterText(find.byKey(const Key('input-name')), 'Bola Basket');
    await tester.enterText(find.byKey(const Key('input-detail')),
        'Bola Basket yang Dipakai Pemain Profesional');
    await tester.enterText(find.byKey(const Key('input-price')), '150000');
    await tester.enterText(find.byKey(const Key('input-stock')), '250');
    //await tester.tap(find.text('Save'));

    await tester.pump();
  });
}
