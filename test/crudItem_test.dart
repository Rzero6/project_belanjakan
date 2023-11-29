import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:project_belanjakan/model/item.dart';
import 'package:project_belanjakan/services/api/auth_client.dart';
import 'package:project_belanjakan/services/api/item_client.dart';

void main() {
  test('add success', () async {
    final user = await AuthClient.loginTesting('test@gmail.com', 'TestPasword');
    final token = user.token;
    Item item = Item(
        id: 0,
        name: 'Axel anjeng',
        detail: 'Orang paling anjeng',
        image: 'image test',
        price: 100,
        stock: 1);
    Response result = await ItemClient.addItemTesting(item, token!);
    expect(result.statusCode, equals(200));
  });

  test('show success', () async {
    Item result = await ItemClient.findItem(3);
    expect(result.name, equals('Gigolos'));
  });

  test('edit success', () async {
    final user =
        await AuthClient.loginTesting('test@gmail.com', 'TestPassword');
    final token = user.token;
    Item item = Item(
        id: 0,
        name: 'Test Update',
        detail: 'Updateed',
        image: 'image test',
        price: 1000,
        stock: 10);
    Response result = await ItemClient.updateItem(item, token!);
    expect(result.statusCode, equals(200));
  });
  test('delete success', () async {
    final user =
        await AuthClient.loginTesting('test@gmail.com', 'TestPassword');
    final token = user.token;
    Response result = await ItemClient.deleteItem(6, token!);
    expect(result.statusCode, equals(200));
  });
}
