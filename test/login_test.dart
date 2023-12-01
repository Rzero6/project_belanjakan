import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_belanjakan/services/api/auth_client.dart';
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

testWidgets('login success', (WidgetTester tester) async {
    await tester.pumpWidget(
      ResponsiveSizer(
        builder: (context, orientation, deviceType) {
          final double containerHeight =
              Device.orientation == Orientation.portrait ? 20.5.h : 12.5.h;

          return MaterialApp(
            home: Container(
              width: 100.w,
              height: containerHeight,
              child: ProviderScope(child: Loginview()),
            ),
          );
        },
      ),
    );

    await tester.enterText(find.byKey(const Key('input-email')), 'akatuskikh@gmail.com');
    await tester.enterText(find.byKey(const Key('input-password')), '12345678!');
    await tester.tap(find.byKey(ValueKey('login')));

    await tester.pump();
    expect(find.byType(ScaffoldMessenger), findsOneWidget);
  });

}
