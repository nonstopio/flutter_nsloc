import 'package:flutter_test/flutter_test.dart';
import 'package:nsio_flutter/models/user.dart';
import 'package:nsio_flutter/utils/keys/api_keys.dart';

void main() {
  test('User.fromMap Test 01 : null data', () {
    User user = User.fromMap(null);
    expect(user.id, 0);
    expect(user.loggedIn, false);
    expect(user.name, "");
    expect(user.marks, 0);
    expect(user.knowLanguages, []);
  });

  test('User.fromMap Test 02 : invalid data', () {
    User user = User.fromMap({'loggedIn': "data"});
    expect(user.id, 0);
    expect(user.loggedIn, false);
    expect(user.name, "");
    expect(user.marks, 0);
    expect(user.knowLanguages, []);
  });

  test('User.fromMap Test 02 : valid data', () {
    User user = User.fromMap({
      APIKeys.id: "1",
      APIKeys.loggedIn: true,
      APIKeys.name: "NonStopIO",
      APIKeys.marks: 99.33,
      APIKeys.knowLanguages: ['Eng'],
    });
    expect(user.id, 1);
    expect(user.loggedIn, true);
    expect(user.name, "NonStopIO");
    expect(user.marks, 99.33);
    expect(user.knowLanguages, ['Eng']);
  });
}
