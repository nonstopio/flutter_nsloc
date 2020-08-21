import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nsio_flutter/models/google_map_model.dart';
import 'package:nsio_flutter/services/api.dart';
import 'package:nsio_flutter/utils/app_logs.dart';
import 'package:nsio_flutter/utils/keys/api_keys.dart';

class GoogleMapService {
  static Future<List<PlacePrediction>> getPlacePrediction(BuildContext context, {@required String input}) async {
    List<PlacePrediction> _placePredictionList = List();
    Map<String, dynamic> responseData = await getDataFromGETAPI(apiName: GoogleMapAPI.getAutoCompleteUrl(input), context: context, useBaseURL: false);
    List predictionData = responseData[GoogleMapKeys.predictions] ?? List();
    _placePredictionList = predictionData.map((data) => PlacePrediction.fromMapAutoComplete(data)).toList();
    return _placePredictionList;
  }

  static Future<PlaceDetails> getPlaceDetails(BuildContext context, {@required String placeId}) async {
    PlaceDetails placeDetails = PlaceDetails.empty();
    appLogs("getPlaceDetails $placeId");
    if (placeId.isEmpty) {
      return placeDetails;
    }
    Map<String, dynamic> responseData = await getDataFromGETAPI(apiName: GoogleMapAPI.placeDetails + placeId, context: context, useBaseURL: false);

    return PlaceDetails.fromMap(responseData[GoogleMapKeys.result] ?? Map());
  }

  static Future<String> getAddress(BuildContext context, LatLng location) async {
    try {
      Map<String, dynamic> responseData = await getDataFromGETAPI(apiName: GoogleMapAPI.getAddress(location), context: context, useBaseURL: false);

      return responseData[GoogleMapKeys.results][0][GoogleMapKeys.formattedAddress];
    } catch (e) {
      print(e);
    }

    return "";
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
      Map structuredFormattingData = data[GoogleMapKeys.structuredFormatting] ?? Map();
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
  static String placeDetails = "https://maps.googleapis.com/maps/api/place/details/json?key=${APIKeys.googleMapsAPIKey}&placeid=";

  static String getPhotoUrl(String photoReference) {
    return "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photoReference&key=${APIKeys.googleMapsAPIKey}";
  }

  static String getAddress(LatLng location) {
    return 'https://maps.googleapis.com/maps/api/geocode/json?latlng=${location?.latitude},${location?.longitude}&key=${APIKeys.googleMapsAPIKey}';
  }

  static String getAutoCompleteUrl(String input) {
    return "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=${APIKeys.googleMapsAPIKey}";
  }
}
