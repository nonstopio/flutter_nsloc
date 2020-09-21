import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ns_google_map_location_picker/models/google_map_model.dart';
import 'package:ns_google_map_location_picker/services/api.dart';
import 'package:ns_google_map_location_picker/utils/keys/api_keys.dart';


class GoogleMapService {
  static Future<List<PlacePrediction>> getPlacePrediction(BuildContext context, {@required String input,String googleMapsAPIKey}) async {
    List<PlacePrediction> _placePredictionList = List();
    Map<String, dynamic> responseData = await getDataFromGETAPI(apiName: GoogleMapAPI.getAutoCompleteUrl(input,googleMapsAPIKey), context: context, useBaseURL: false);
    List predictionData = responseData[GoogleMapKeys.predictions] ?? List();
    _placePredictionList = predictionData.map((data) => PlacePrediction.fromMapAutoComplete(data)).toList();
    return _placePredictionList;
  }

  static Future<PlaceDetails> getPlaceDetails(BuildContext context, {@required String placeId,@required String googleMapsAPIKey}) async {
    PlaceDetails placeDetails = PlaceDetails.empty();
    print("getPlaceDetails $placeId");
    if (placeId.isEmpty) {
      return placeDetails;
    }
    Map<String, dynamic> responseData = await getDataFromGETAPI(apiName: GoogleMapAPI.getPlaceDetails(googleMapsAPIKey,placeId), context: context, useBaseURL: false);

    return PlaceDetails.fromMap(responseData[GoogleMapKeys.result] ?? Map());
  }

  static Future<String> getAddress(BuildContext context, LatLng location ,String googleMapsAPIKey) async {
    try {
      Map<String, dynamic> responseData = await getDataFromGETAPI(apiName: GoogleMapAPI.getAddress(location,googleMapsAPIKey), context: context, useBaseURL: false);

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
    print("PlacePrediction.fromMapAutoComplete Data : $data");
    try {
      Map structuredFormattingData = data[GoogleMapKeys.structuredFormatting] ?? Map();
      return PlacePrediction(
        placeId: data[GoogleMapKeys.placeId] ?? "",
        name: structuredFormattingData[GoogleMapKeys.mainText] ?? "",
        description: data[GoogleMapKeys.description] ?? "",
      );
    } on Exception catch (e, s) {
      print("PlacePrediction.fromMapAutoComplete Exception : $e\n$s");
    }
    return PlacePrediction.empty();
  }

  factory PlacePrediction.fromMapNearBy(Map data) {
    print("PlacePrediction.fromMapAutoComplete Data : $data");
    try {
      return PlacePrediction(
        placeId: data[GoogleMapKeys.placeId] ?? "",
        name: data[GoogleMapKeys.name] ?? "",
        description: data[GoogleMapKeys.vicinity] ?? "",
      );
    } on Exception catch (e, s) {
      print("PlacePrediction.fromMapAutoComplete Exception : $e\n$s");
    }
    return PlacePrediction.empty();
  }

  Map<String, dynamic> toMap() => {
        GoogleMapKeys.placeId: this.placeId,
        GoogleMapKeys.name: this.name,
        GoogleMapKeys.description: this.description,
      };

  logPlaceDetails() {
    print("=======PlaceDetails=======");
    this.toMap().forEach((k, v) {
      print("$k : $v");
    });
  }
}

class GoogleMapAPI {
//GoogleMaps API NAMES
  static String getPlaceDetails(String googleMapsAPIKey,String placeId) {
      return"https://maps.googleapis.com/maps/api/place/details/json?key=$googleMapsAPIKey&placeid=$placeId";
  }

  static String getPhotoUrl(String photoReference,String googleMapsAPIKey) {
    return "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photoReference&key=$googleMapsAPIKey";
  }

  static String getAddress(LatLng location,String googleMapsAPIKey) {
    return 'https://maps.googleapis.com/maps/api/geocode/json?latlng=${location?.latitude},${location?.longitude}&key=$googleMapsAPIKey';
  }

  static String getAutoCompleteUrl(String input,String googleMapsAPIKey) {
    return "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$googleMapsAPIKey";
  }
}
