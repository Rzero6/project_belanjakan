import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_belanjakan/services/api/auth_client.dart';
import 'package:project_belanjakan/view/main/main_menu.dart';
import 'package:project_belanjakan/view/products/product_details.dart';
import 'package:project_belanjakan/view/products/product_grid_show.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mockito/mockito.dart';

class MockImagePicker extends Mock implements ImagePicker {}

void main() {
  final TestWidgetsFlutterBinding binding =
      TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() => HttpOverrides.global = null);

  testWidgets('create success', (WidgetTester tester) async {
    debugCheckIntrinsicSizes = false;
    try {
      final hasil =
          await AuthClient.loginTesting('akatsukikh99@gmail.com', '12345678!');
      final token = hasil.token;
      SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
      await sharedPrefs.setString('token', token!);
      await sharedPrefs.setInt('userID', hasil.id!);
      await sharedPrefs.setString('email', hasil.email);
    } catch (e) {
      print(e.toString());
    }

    await tester.pumpWidget(
      ResponsiveSizer(
        builder: (context, orientation, deviceType) {
          final double containerHeight =
              Device.orientation == Orientation.portrait ? 20.5.h : 12.5.h;

          return MaterialApp(
            home: SizedBox(
              width: 100.w,
              height: containerHeight,
              child: const ProviderScope(
                child: ProductDetailScreen(
                  id: 1,
                  amount: 1,
                ),
              ),
            ),
          );
        },
      ),
    );

    expect(find.byType(ProductDetailScreen), findsWidgets);
    await tester.pumpAndSettle();
    await tester.tap(find.text('ADD TO CART'));
    await tester.pumpAndSettle();
    expect(find.byType(ProductDetailScreen), findsNothing);
    await tester.pumpAndSettle();
  });
}
