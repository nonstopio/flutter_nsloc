import 'package:flutter/cupertino.dart';
import 'package:geopoint/geopoint.dart';
import 'package:nsio_flutter/screens/location/google_maps_service.dart';
import 'package:nsio_flutter/utils/app_logs.dart';
import 'package:nsio_flutter/utils/keys/api_keys.dart';

class PlaceDetails {
  String placeId;
  String name;
  String formattedAddress;
  String internationalPhoneNumber;
  String rating;
  String url;
  String vicinity;
  String website;
  List<String> photos;
  List<String> weekdayText;
  List<String> types;
  GeoPoint location;

  PlaceDetails({
    @required this.placeId,
    @required this.name,
    @required this.formattedAddress,
    @required this.internationalPhoneNumber,
    @required this.rating,
    @required this.url,
    @required this.vicinity,
    @required this.website,
    @required this.photos,
    @required this.weekdayText,
    @required this.types,
    @required this.location,
  });

  factory PlaceDetails.empty() => PlaceDetails(
    placeId: "",
    name: "",
    formattedAddress: "",
    internationalPhoneNumber: "",
    rating: "",
    url: "",
    vicinity: "",
    website: "",
    photos: [],
    weekdayText: [],
    types: [],
    location: GeoPoint(latitude: 0, longitude: 0),
  );

  factory PlaceDetails.fromMap(Map data) {
    apiLogs("PlaceDetails.fromMap Data : $data");
    try {
      Map openingHoursData = data[GoogleMapKeys.openingHours] ?? Map();
      Map geometryData = data[GoogleMapKeys.geometry] ?? Map();
      Map locationData = geometryData[GoogleMapKeys.location] ?? Map();
      return PlaceDetails(
        placeId: data[GoogleMapKeys.placeId] ?? "",
        name: data[GoogleMapKeys.name] ?? "",
        formattedAddress: data[GoogleMapKeys.formattedAddress] ?? "",
        internationalPhoneNumber:
        data[GoogleMapKeys.internationalPhoneNumber] ?? "",
        rating: '${data[GoogleMapKeys.rating] ?? 0}',
        url: data[GoogleMapKeys.url] ?? "",
        vicinity: data[GoogleMapKeys.vicinity] ?? "",
        website: data[GoogleMapKeys.website] ?? "",
        photos: List.from((data[GoogleMapKeys.photos] ?? [])
            .map((photoData) => GoogleMapAPI.getPhotoUrl(
            photoData[GoogleMapKeys.photoReference]))
            .toList()),
        weekdayText:
        List.from(openingHoursData[GoogleMapKeys.weekdayText] ?? []),
        types: List.from(data[GoogleMapKeys.types] ?? []),
        location: GeoPoint(
          latitude: locationData[GoogleMapKeys.lat] ?? 0,
          longitude: locationData[GoogleMapKeys.lng] ?? 0,
        ),
      );
    } on Exception catch (e, s) {
      apiLogs("PlaceDetails.fromMap Exception : $e\n$s");
    }
    return PlaceDetails.empty();
  }

  Map<String, dynamic> toMap() => {
    GoogleMapKeys.placeId: this.placeId,
    GoogleMapKeys.name: this.name,
    GoogleMapKeys.formattedAddress: this.formattedAddress,
    GoogleMapKeys.internationalPhoneNumber: this.internationalPhoneNumber,
    GoogleMapKeys.rating: this.rating,
    GoogleMapKeys.url: this.url,
    GoogleMapKeys.vicinity: this.vicinity,
    GoogleMapKeys.website: this.website,
    GoogleMapKeys.photos: this.photos,
    GoogleMapKeys.weekdayText: this.weekdayText,
    GoogleMapKeys.types: this.types,
    GoogleMapKeys.location: this.location,
  };

  logPlaceDetails() {
    appLogs("=======PlaceDetails=======");
    this.toMap().forEach((k, v) {
      apiLogs("$k : $v");
    });
  }

  isEmpty() {
    return this.formattedAddress.isEmpty &&
        this.internationalPhoneNumber.isEmpty &&
        this.website.isEmpty &&
        this.weekdayText.isEmpty;
  }
}
