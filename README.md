# location_picker

Getting Started
Get an API key at https://cloud.google.com/maps-platform/.

and don't forget to enable in https://console.cloud.google.com/google/maps-apis/

Maps SDK for Android
Maps SDK for iOS
Places API
Geolocation API
Geocoding API
Android
Specify your API key in the application manifest android/app/src/main/AndroidManifest.xml:

<manifest ...
  <application ...
    <meta-data android:name="com.google.android.geo.API_KEY"
               android:value="YOUR KEY HERE"/>
iOS
Specify your API key in the application delegate ios/Runner/AppDelegate.m:

#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#import "GoogleMaps/GoogleMaps.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GMSServices provideAPIKey:@"YOUR KEY HERE"];
  [GeneratedPluginRegistrant registerWithRegistry:self];
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}
@end
Or in your swift code, specify your API key in the application delegate ios/Runner/AppDelegate.swift:

import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("YOUR KEY HERE")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
Opt-in to the embedded views preview by adding a boolean property to the app's Info.plist file with the key io.flutter.embedded_views_preview and the value YES; you need also to define NSLocationWhenInUseUsageDescription

  <key>NSLocationWhenInUseUsageDescription</key>
  <string>This app needs your location to test the location feature of the Google Maps location picker plugin.</string>
  <key>io.flutter.embedded_views_preview</key>
  <true/>
Note
The following permissions are not required to use Google Maps Android API v2, but are recommended.

android.permission.ACCESS_COARSE_LOCATION Allows the API to use WiFi or mobile cell data (or both) to determine the device's location. The API returns the location with an accuracy approximately equivalent to a city block.

android.permission.ACCESS_FINE_LOCATION Allows the API to determine as precise a location as possible from the available location providers, including the Global Positioning System (GPS) as well as WiFi and mobile cell data.

You must also explicitly declare that your app uses the android.hardware.location.network or android.hardware.location.gps hardware features if your app targets Android 5.0 (API level 21) or higher and uses the ACCESS_COARSE_LOCATION or ACCESS_FINE_LOCATION permission in order to receive location updates from the network or a GPS, respectively.

<uses-feature android:name="android.hardware.location.network" android:required="false" />
<uses-feature android:name="android.hardware.location.gps" android:required="false"  />
The following permissions are defined in the package manifest, and are automatically merged into your app's manifest at build time. You don't need to add them explicitly to your manifest:

android.permission.INTERNET Used by the API to download map tiles from Google Maps servers.

android.permission.ACCESS_NETWORK_STATE Allows the API to check the connection status in order to determine whether data can be downloaded.
