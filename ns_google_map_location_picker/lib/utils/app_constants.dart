///App Constants
///

const int timeOutCode = 504;
const int serverErrorCode = 500;
const int timeOutSecond = 500;
const int errorStatusCode = 0;

class AppConstants {
  /*Delay Constants*/
  static const int delayExtraSmall = 100;
  static const int delaySmall = 200;
  static const int delayMedium = 500;
  static const int delayLarge = 1000;
  static const int delayXL = 1500;
  static const int delayXXL = 2000;

  static const String comma = ",";
  static const double zoomValue = 10;
  static const double afterZoomValue = 15;
  static const double defaultZoomValue = 12;
  static const double latitude = 0;
  static const double longitude = 0;
  static const double markerBitmapDescriptor = 150.0;

  static const Duration splashDelay = const Duration(
    milliseconds: AppConstants.delayLarge,
  );
}
