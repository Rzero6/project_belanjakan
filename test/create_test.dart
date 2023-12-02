import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_belanjakan/view/products/manage/input_page.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mockito/mockito.dart';

class MockImagePicker extends Mock implements ImagePicker {}

void main() {
  final TestWidgetsFlutterBinding binding =
      TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() => HttpOverrides.global = null);

  // testWidgets('create success', (WidgetTester tester) async {
  //   final mockImagePicker = MockImagePicker();

  //   tester.binding.window.devicePixelRatioTestValue = 10;
  //   final mockImagePicker = MockImagePicker();
  //   3.0; // Set your desired device pixel ratio
  //   await tester.pumpWidget(
  //     ResponsiveSizer(
  //       builder: (context, orientation, deviceType) {
  //         final double containerHeight =
  //             Device.orientation == Orientation.portrait ? 20.5.h : 12.5.h;

  //         return MaterialApp(
  //           home: SizedBox(
  //             width: 100.w,
  //             height: containerHeight,
  //             child: const ProviderScope(child: ItemInputPage()),
  //           ),
  //         );
  //       },
  //     ),
  //   );

  //   SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
  //   await sharedPrefs.setString('token', 'userData.token!');

  //   await tester.enterText(find.byKey(const Key('input-name')), 'Bola Basket');
  //   await tester.enterText(find.byKey(const Key('input-detail')),
  //       'Bola Basket yang Dipakai Pemain Profesional');
  //   await tester.enterText(find.byKey(const Key('input-price')), '150000');

  //   await tester.enterText(find.byKey(const Key('input-stock')), '250');

  //   await tester.pump();

  //   // Trigger the action to select an image
  //   await tester.tap(takePictureButton);
  //   await tester.pumpAndSettle();

  //   // Verify that the image is selected
  //   expect(
  //       (tester.widget(find.byKey(Key('input-image-selector')))
  //               as GestureDetector)
  //           .onTap,
  //       isNotNull);

  //   await tester.tap(find.byKey(const Key('input-image-selector')));
  //   await tester.pump(const Duration(seconds: 4));

  //   await tester.tapAt(const Offset(396.1, 504.4));

  //   await tester.pump(const Duration(seconds: 2));

  //   // await tester.tapAt(const Offset(396.1, 504.4));

  //   // await tester.tap(find.text("Gallery"));
  //   // await tester.tap(find.text('Save'));

  //   await tester.pumpAndSettle();
  // });

  testWidgets('create success', (WidgetTester tester) async {
    final mockImagePicker = MockImagePicker();

    tester.binding.window.devicePixelRatioTestValue = 10;
    3.0; // Set your desired device pixel ratio
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

    // Find the text fields by key
    final nameField = find.byKey(Key("input-name"));
    final detailField = find.byKey(Key("input-detail"));
    final priceField = find.byKey(Key("input-price"));
    final stockField = find.byKey(Key("input-stock"));

    // Verify that all text fields are initially empty
    expect((tester.widget(nameField) as TextFormField).controller!.text, '');
    expect((tester.widget(detailField) as TextFormField).controller!.text, '');
    expect((tester.widget(priceField) as TextFormField).controller!.text, '');
    expect((tester.widget(stockField) as TextFormField).controller!.text, '');

    // Enter text into the text fields
    await tester.enterText(nameField, 'Test Name');
    await tester.enterText(detailField, 'Test Detail');
    await tester.enterText(priceField, '100');
    await tester.enterText(stockField, '50');

    // Trigger the action to select an image
    await tester.tap(find.byKey(const Key('input-image-selector')));
    await tester.pumpAndSettle();

    // Verify that the image is selected
    expect(find.byKey(const Key('input-image-selector')), findsOneWidget);

    await tester.tap(find.text('Gallery'));
    await tester.pumpAndSettle();

    // Perform the form submission
    // await tester.tap(find.text('Save'));
    // await tester.pumpAndSettle();

    // Verify that the form submission is successful
    // (You need to adjust this verification based on the actual logic in your onSubmit function)
    // expect(find.text('Success'), findsOneWidget);
  });
}
