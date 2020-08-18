import 'app.dart';

void main() async {
  App.instance.initAndRunApp(
    devMode: true,
    appLog: true,
    apiLog: false,
  );
}
