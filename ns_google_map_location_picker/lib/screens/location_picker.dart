library ns_google_map_location_picker;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ns_google_map_location_picker/common_widgets/maps_widget.dart';
import 'package:ns_google_map_location_picker/models/google_map_model.dart';
import 'package:ns_google_map_location_picker/services/google_maps_service.dart';
import 'package:ns_google_map_location_picker/utils/app_constants.dart';
import 'package:ns_google_map_location_picker/utils/sizes.dart';
import 'package:ns_google_map_location_picker/utils/strings.dart';
import 'package:screen_loader/screen_loader.dart';


class MyMap extends StatefulWidget {
  final googleMapsKey;

  const MyMap({Key key, @required this.googleMapsKey}) : super(key: key);

  @override
  State createState() {
    // TODO: implement createState
    return MyMapState();
  }
}

class MyMapState extends State<MyMap> with ScreenLoader<MyMap> {
  LatLng _latLong = LatLng(AppConstants.latitude, AppConstants.longitude);
  CameraPosition _cameraPosition;
  GoogleMapController _googleMapController;
  String _address = "";

  Set<Marker> _markers = {};
  TextEditingController _searchTextController = TextEditingController();
  List<PlacePrediction> _placePredictionList = List();
  bool _showSearchSuggestions = false;
  Timer _throttle;
  String _previousResult = "";
  var dialogOpen;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cameraPosition = CameraPosition(target: LatLng(AppConstants.latitude, AppConstants.longitude), zoom: AppConstants.zoomValue);
    _searchTextController.addListener(_onSearchChanged);
    _getCurrentLocation();
    print("LocationScreen");
  }

  @override
  void dispose() {
    _searchTextController.removeListener(_onSearchChanged);
    _searchTextController.dispose();
    super.dispose();
  }

  _getLocationResults(String input) async {
    _placePredictionList = await GoogleMapService.getPlacePrediction(context, input: input,googleMapsAPIKey: widget.googleMapsKey);
    print("getLocationResults ${_placePredictionList.length}");
    if (_placePredictionList.length >= 1) {
      setState(() {
        _showSearchSuggestions = true;
      });
    } else {
      setState(() {
        _showSearchSuggestions = false;
      });
    }
  }

  _onSearchChanged() {
    if (_throttle?.isActive ?? false) _throttle.cancel();
    _throttle = Timer(const Duration(milliseconds: AppConstants.delayMedium), () {
      if (_previousResult != _searchTextController.text) {
        _getLocationResults(_searchTextController.text);
        setState(() {
          _previousResult = _searchTextController.text;
        });
      }
    });
  }

  _getCurrentLocation() async {
    startLoading();
    Position position;
    try {
      final Geolocator geolocator = Geolocator()..forceAndroidLocationManager = true;
      position = await geolocator.getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);
      print(position.latitude);
    } on PlatformException {
      position = null;
    }

    if (position == null) {
      stopLoading();
      return;
    }

    _getCurrentAddress(position);

    setState(() {
      _latLong = new LatLng(position.latitude, position.longitude);
      _cameraPosition = CameraPosition(target: _latLong, zoom: AppConstants.zoomValue);
      if (_googleMapController != null) _googleMapController.animateCamera(CameraUpdate.newCameraPosition(_cameraPosition));
      print(_searchTextController.toString());
      _markers.add(Marker(
        markerId: MarkerId("ID"),
        position: _latLong,
      ));
    });
    stopLoading();
  }

  _getCurrentAddress(Position position) async {
    _address = await GoogleMapService.getAddress(context, LatLng(position.latitude, position.longitude),widget.googleMapsKey);
  }

  @override
  Widget screen(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            iconTheme: Theme.of(context).iconTheme,
            title: Text(Strings.searchPlace),
          ),
          body: Stack(
            children: [
              GoogleMap(
                initialCameraPosition: _cameraPosition,
                onCameraMove: (CameraPosition position) {
                  _markers.clear();
                  _markers.add(
                    Marker(
                      markerId: MarkerId("Marker"),
                      position: position.target,
                    ),
                  );
                  _latLong = position.target;
                  setState(() {});
                },
                onCameraIdle: () async {
                  _address = await GoogleMapService.getAddress(context, _latLong, widget.googleMapsKey);
                  setState(() {});
                },
                onMapCreated: (GoogleMapController controller) {
                  _googleMapController = (controller);
                  _googleMapController.animateCamera(CameraUpdate.newCameraPosition(_cameraPosition));
                },
                markers: _markers,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
              ),
              Container(
                margin: EdgeInsets.all(Sizes.s10),
                child: Column(
                  children: <Widget>[
                    Container(
                      width: screenWidth,
                      color: Colors.white,
                      padding: EdgeInsets.all(Sizes.s20),
                      child: Text(_address.isEmpty ? Strings.unnamedPlace : _address),
                    ),
                    SizedBox(
                      width: Sizes.s10,
                      height: Sizes.s10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Theme.of(context).brightness == Brightness.dark ? Colors.black54 : Colors.white,
                      ),
                      padding: EdgeInsets.all(Sizes.s5),
                      child: TextField(
                        controller: _searchTextController,
                        decoration: InputDecoration(
                          hintText: Strings.searchPlace,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    if (_showSearchSuggestions)
                      Flexible(
                        child: ListView(
                          padding: EdgeInsets.symmetric(
                            horizontal: Sizes.s20,
                          ),
                          children: _placePredictionList
                              .map((placePrediction) => SelectPredictionWidget(
                            placePrediction: placePrediction,
                            onTap: () async {
                              startLoading();
                              FocusScope.of(context);
                              setState(() {
                                _showSearchSuggestions = false;
                              });
                              PlaceDetails placeDetails = await GoogleMapService.getPlaceDetails(context, placeId: placePrediction.placeId,googleMapsAPIKey: widget.googleMapsKey);
                              setState(() {
                                _markers.clear();
                                _markers.add(
                                  Marker(
                                    markerId: MarkerId(placePrediction.placeId),
                                    position: LatLng(placeDetails.location.latitude, placeDetails.location.longitude),
                                    icon: BitmapDescriptor.defaultMarkerWithHue(AppConstants.markerBitmapDescriptor),
                                    infoWindow: InfoWindow(title: placeDetails.name, snippet: placeDetails.formattedAddress),
                                  ),
                                );
                                _address = placeDetails.formattedAddress;
                              });
                              await _googleMapController?.animateCamera(
                                CameraUpdate.newCameraPosition(
                                  CameraPosition(
                                    target: LatLng(
                                      placeDetails.location.latitude,
                                      placeDetails.location.longitude,
                                    ),
                                    zoom: AppConstants.afterZoomValue,
                                  ),
                                ),
                              );
                              stopLoading();
                            },
                          ))
                              .toList(),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}