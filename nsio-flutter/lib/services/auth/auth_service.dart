import 'package:nsio_flutter/models/user.dart';
import 'package:nsio_flutter/services/shared_preferences/sp_service.dart';
import 'package:nsio_flutter/utils/app_logs.dart';
import 'package:nsio_flutter/utils/keys/sp_keys.dart';
import 'package:nsio_flutter/utils/methods.dart';

///[auth] to access current authenticated user
///
final Auth auth = new Auth();

class Auth {
  User currentUser;

  Auth() {
    currentUser = User.empty();
  }

  ///Loads [currentUser] From Shared Preferences
  ///
  Future<Null> loadUser() async {
    appLogs("Loads [currentUser]");
    auth.currentUser = User.fromMap(
      getMapFromJson(SPService.instance.getString(SPKeys.userData)),
    );
    auth.currentUser.log();
  }

  ///Saves [currentUser] to Shared Preferences
  ///
  Future<Null> saveUser() async {
    appLogs("Saves [currentUser]");
    SPService.instance
        .setString(SPKeys.userData, getJsonFromMap(currentUser.toMap()));
    currentUser.log();
  }

  ///clear [currentUser] from Shared Preferences
  ///
  Future<Null> clearUser() async {
    appLogs("clear [currentUser]");
    currentUser = User.empty();
    SPService.instance.clear();
  }
}
