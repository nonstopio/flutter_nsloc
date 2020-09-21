import 'package:flutter/cupertino.dart';
import 'package:geopoint/geopoint.dart';
import 'package:ns_google_map_location_picker/utils/keys/api_keys.dart';

class PlaceDetails {
  String placeId;
  String name;
  String formattedAddress;
  String internationalPhoneNumber;
  String rating;
  String url;
  String vicinity;
  String website;
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
        weekdayText: [],
        types: [],
        location: GeoPoint(latitude: 0, longitude: 0),
      );

  factory PlaceDetails.fromMap(Map data) {
    print("PlaceDetails.fromMap Data : $data");
    try {
      Map openingHoursData = data[GoogleMapKeys.openingHours] ?? Map();
      Map geometryData = data[GoogleMapKeys.geometry] ?? Map();
      Map locationData = geometryData[GoogleMapKeys.location] ?? Map();
      return PlaceDetails(
        placeId: data[GoogleMapKeys.placeId] ?? "",
        name: data[GoogleMapKeys.name] ?? "",
        formattedAddress: data[GoogleMapKeys.formattedAddress] ?? "",
        internationalPhoneNumber: data[GoogleMapKeys.internationalPhoneNumber] ?? "",
        rating: '${data[GoogleMapKeys.rating] ?? 0}',
        url: data[GoogleMapKeys.url] ?? "",
        vicinity: data[GoogleMapKeys.vicinity] ?? "",
        website: data[GoogleMapKeys.website] ?? "",
        weekdayText: List.from(openingHoursData[GoogleMapKeys.weekdayText] ?? []),
        types: List.from(data[GoogleMapKeys.types] ?? []),
        location: GeoPoint(
          latitude: locationData[GoogleMapKeys.lat] ?? 0,
          longitude: locationData[GoogleMapKeys.lng] ?? 0,
        ),
      );
    } on Exception catch (e, s) {
      print("PlaceDetails.fromMap Exception : $e\n$s");
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
        GoogleMapKeys.weekdayText: this.weekdayText,
        GoogleMapKeys.types: this.types,
        GoogleMapKeys.location: this.location,
      };

  logPlaceDetails() {
    print("=======PlaceDetails=======");
    this.toMap().forEach((k, v) {
      print("$k : $v");
    });
  }

  isEmpty() {
    return this.formattedAddress.isEmpty && this.internationalPhoneNumber.isEmpty && this.website.isEmpty && this.weekdayText.isEmpty;
  }
}
