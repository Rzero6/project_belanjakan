import 'package:flutter_test/flutter_test.dart';
import 'package:project_belanjakan/services/api/auth_client.dart';

void main() {
  test('login success', () async {
    final hasil =
        await AuthClient.loginTesting('test@gmail.com', 'TestPasword');
    expect(hasil.name, equals('Test'));
  });

  test('login failed', () async {
    final result = await AuthClient.loginTesting("email@email.com", "password");
    expect(result, null);
  });
}
