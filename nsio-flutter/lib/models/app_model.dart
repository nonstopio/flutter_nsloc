///[AppModel] an [abstract] class
///
/// All model class should implements [AppModel]
///
abstract class AppModel {
  ///to model convert [Object] to [Map]
  ///
  Map toMap();

  ///to log model [Object] to console
  ///
  ///if [App.instance.appLog] is enabled
  ///
  void log();
}
