import 'package:meta/meta.dart';
import 'package:nsio_flutter/services/extensions/map_extension.dart';
import 'package:nsio_flutter/utils/app_logs.dart';
import 'package:nsio_flutter/utils/keys/api_keys.dart';

import 'app_model.dart';

///[User] sample user models
///
class User implements AppModel {
  bool loggedIn;
  int id;
  String name;
  double marks;
  List<String> knowLanguages;

  User({
    @required this.loggedIn,
    @required this.id,
    @required this.name,
    @required this.marks,
    @required this.knowLanguages,
  });

  factory User.empty() => User(
        loggedIn: defaultBool,
        id: defaultInt,
        name: defaultString,
        marks: defaultDouble,
        knowLanguages: [],
      );

  factory User.fromMap(Map<String, dynamic> data) {
    apiLogs("User.fromMap Data : $data");
    try {
      return User(
        loggedIn: data.getBool(APIKeys.loggedIn),
        id: data.getInt(APIKeys.id),
        name: data.getString(APIKeys.name),
        marks: data.getDouble(APIKeys.marks),
        knowLanguages: List<String>.from(
            data.getList<String>(APIKeys.knowLanguages).map((e) => e).toList()),
      );
    } catch (e, s) {
      errorLogs("User.fromMap Exception : $e\n$s");
    }

    return User.empty();
  }

  @override
  Map<String, dynamic> toMap() => {
        APIKeys.loggedIn: loggedIn,
        APIKeys.id: id,
        APIKeys.name: name,
        APIKeys.marks: marks,
        APIKeys.knowLanguages: knowLanguages,
      };

  @override
  void log() {
    String data = "User";
    toMap().forEach((k, v) {
      data += ("\n$k : $v");
    });
    apiLogs(data);
  }
}
