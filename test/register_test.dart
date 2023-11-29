import 'package:flutter_test/flutter_test.dart';
import 'package:project_belanjakan/model/user.dart';
import 'package:project_belanjakan/services/api/auth_client.dart';

void main() {
  test('register success', () async {
    User user = User(
        name: 'Test',
        password: 'TestPasword',
        email: 'test@gmail.com',
        phone: '0812312512',
        dateOfBirth: DateTime.now().toIso8601String());
    final hasil = await AuthClient.registerTesting(user);
    expect(hasil, equals('Register Success'));
  });

  test('register failed', () async {
    User user = User(
        name: 'Test',
        password: 'TestPasword',
        email: 'test@gmail.com',
        phone: '0812312512',
        dateOfBirth: DateTime.now().toIso8601String());
    final hasil = await AuthClient.registerTesting(user);
    expect(hasil, 'The email has already been taken.');
  });
}
