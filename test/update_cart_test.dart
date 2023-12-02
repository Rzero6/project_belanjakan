import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_belanjakan/main.dart';
import 'package:project_belanjakan/model/cart.dart';
import 'package:project_belanjakan/services/api/auth_client.dart';
import 'package:project_belanjakan/services/api/cart_client.dart';
import 'package:project_belanjakan/view/landing/login_page.dart';
import 'package:project_belanjakan/view/main/shoppingCart_page.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() => HttpOverrides.global = null);

  testWidgets('Update cart success success', (WidgetTester tester) async {
    final userData =
        await AuthClient.loginTesting('akatsukikh99@gmail.com', '12345678!');
    expect(userData.token, isNotNull);

    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();

    await sharedPrefs.setInt('userID', userData.id!);
    await sharedPrefs.setString('username', userData.name);
    await sharedPrefs.setString('email', userData.email);
    await sharedPrefs.setString('profile_pic', userData.profilePicture ?? "");
    await sharedPrefs.setString('token', userData.token!);

    await CartClient.addOrUpdateCart(
        Cart(id: 0, idUser: 0, idItem: 1, amount: 3),
        userData.token!); // klo di device lain pastikan pas

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
                child: const ShoppingCart(),
              ),
            );
          },
        ),
      ),
    );

    await tester.pumpAndSettle();
    await tester.dragFrom(
        const Offset(394.4, 277.2), const Offset(397.2, 429.9));
    await tester.pumpAndSettle();

    await tester.tapAt(const Offset(187.2, 82.8));

    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '7');
    await tester.pumpAndSettle();
    await tester.tap(find.text('ADD TO CART'));
    await tester.pumpAndSettle();
    await tester.dragFrom(
        const Offset(394.4, 277.2), const Offset(397.2, 429.9));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(Row, 'Jumlah: 5'), findsOneWidget);
  });
}
