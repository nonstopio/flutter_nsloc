import 'package:flutter/material.dart';
import 'package:geopoint/geopoint.dart';
import 'package:shengel_app/services/app_services.dart';
import 'package:shengel_app/utils/app_utils.dart';

class GoogleMapService {
  static Future<List<PlacePrediction>> getPlacePrediction(BuildContext context,
      {@required String input}) async {
    List<PlacePrediction> _placePredictionList = List();
    Map<String, dynamic> responseData = await getDataFromGETAPI(
        apiName: GoogleMapAPI.getAutoCompleteUrl(input),
        context: context,
        useBaseURL: false);
    List predictionData = responseData[GoogleMapKeys.predictions] ?? List();
    _placePredictionList = predictionData
        .map((data) => PlacePrediction.fromMapAutoComplete(data))
        .toList();
    return _placePredictionList;
  }

  static Future<PlaceDetails> getPlaceDetails(BuildContext context,
      {@required String placeId}) async {
    PlaceDetails placeDetails = PlaceDetails.empty();
    appLogs("getPlaceDetails $placeId");
    if (placeId.isEmpty) {
      return placeDetails;
    }
    Map<String, dynamic> responseData = await getDataFromGETAPI(
        apiName: GoogleMapAPI.placeDetails + placeId,
        context: context,
        useBaseURL: false);

    return PlaceDetails.fromMap(responseData[GoogleMapKeys.result] ?? Map());
  }
}

class PlacePrediction {
  String placeId;
  String name;
  String description;

  PlacePrediction({
    @required this.placeId,
    @required this.name,
    @required this.description,
  });

  factory PlacePrediction.empty() => PlacePrediction(
        placeId: "",
        name: "",
        description: "",
      );

  factory PlacePrediction.fromMapAutoComplete(Map data) {
    apiLogs("PlacePrediction.fromMapAutoComplete Data : $data");
    try {
      Map structuredFormattingData =
          data[GoogleMapKeys.structuredFormatting] ?? Map();
      return PlacePrediction(
        placeId: data[GoogleMapKeys.placeId] ?? "",
        name: structuredFormattingData[GoogleMapKeys.mainText] ?? "",
        description: data[GoogleMapKeys.description] ?? "",
      );
    } on Exception catch (e, s) {
      apiLogs("PlacePrediction.fromMapAutoComplete Exception : $e\n$s");
    }
    return PlacePrediction.empty();
  }

  factory PlacePrediction.fromMapNearBy(Map data) {
    apiLogs("PlacePrediction.fromMapAutoComplete Data : $data");
    try {
      return PlacePrediction(
        placeId: data[GoogleMapKeys.placeId] ?? "",
        name: data[GoogleMapKeys.name] ?? "",
        description: data[GoogleMapKeys.vicinity] ?? "",
      );
    } on Exception catch (e, s) {
      apiLogs("PlacePrediction.fromMapAutoComplete Exception : $e\n$s");
    }
    return PlacePrediction.empty();
  }

  Map<String, dynamic> toMap() => {
        GoogleMapKeys.placeId: this.placeId,
        GoogleMapKeys.name: this.name,
        GoogleMapKeys.description: this.description,
      };

  logPlaceDetails() {
    apiLogs("=======PlaceDetails=======");
    this.toMap().forEach((k, v) {
      apiLogs("$k : $v");
    });
  }
}

class GoogleMapAPI {
//GoogleMaps API NAMES
  static String placeDetails =
      "https://maps.googleapis.com/maps/api/place/details/json?key=${APIKeys.googleMapsAPIKey}&placeid=";

  static String getPhotoUrl(String photoReference) {
    return "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photoReference&key=${APIKeys.googleMapsAPIKey}";
  }

  static String getAutoCompleteUrl(String input) {
    return "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=${APIKeys.googleMapsAPIKey}";
  }
}

class GoogleMapKeys {
  static const String placeId = "place_id";
  static const String predictions = "predictions";
  static const String result = "result";
  static const String results = "results";
  static const String formattedAddress = "formatted_address";
  static const String internationalPhoneNumber = "international_phone_number";
  static const String name = "name";
  static const String description = "description";
  static const String rating = "rating";
  static const String types = "types";
  static const String url = "url";
  static const String vicinity = "vicinity";
  static const String website = "website";
  static const String photos = "photos";
  static const String openingHours = "opening_hours";
  static const String weekdayText = "weekday_text";
  static const String photoReference = "photo_reference";
  static const String geometry = "geometry";
  static const String location = "location";
  static const String structuredFormatting = "structured_formatting";
  static const String mainText = "main_text";
  static const String lat = "lat";
  static const String lng = "lng";
}

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
