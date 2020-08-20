import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nsio_flutter/common_widgets/maps_widget.dart';
import 'package:nsio_flutter/models/google_map_model.dart';
import 'package:nsio_flutter/screens/location/google_maps_service.dart';
import 'package:nsio_flutter/utils/app_constants.dart';
import 'package:nsio_flutter/utils/methods.dart';
import 'package:screen_loader/screen_loader.dart';

import '../../utils/app_logs.dart';
import '../../utils/sizes.dart';
import '../../utils/strings.dart';

class MyMap extends StatefulWidget {
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cameraPosition = CameraPosition(target: LatLng(AppConstants.latitude, AppConstants.longitude), zoom: AppConstants.zoomValue);
    _searchTextController.addListener(_onSearchChanged);
    _getCurrentLocation();
    appLogs("LocationScreen");
  }

  @override
  void dispose() {
    _searchTextController.removeListener(_onSearchChanged);
    _searchTextController.dispose();
    super.dispose();
  }

  _getLocationResults(String input) async {
    _placePredictionList = await GoogleMapService.getPlacePrediction(context, input: input);
    appLogs("getLocationResults ${_placePredictionList.length}");
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

  @override
  Widget screen(BuildContext context) {
    // TODO: implement build
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
                onMapCreated: (GoogleMapController controller) {
                  _googleMapController = (controller);
                  _googleMapController.animateCamera(CameraUpdate.newCameraPosition(_cameraPosition));
                },
                markers: _markers,
              ),
              Column(
                children: <Widget>[
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(Sizes.s20),
                    child: Text(_address),
                  ),
                  TextField(
                    controller: _searchTextController,
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
                            setFocus(context);
                            setState(() {
                              _showSearchSuggestions = false;
                            });
                            PlaceDetails placeDetails = await GoogleMapService.getPlaceDetails(context, placeId: placePrediction.placeId);
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
                    )
                ],
              ),
            ],
          )),
    );
  }

  _getCurrentLocation() async {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    appLogs(position.latitude);

    List _placemark = await Geolocator().placemarkFromCoordinates(position.latitude, position.longitude);

    _address = await GoogleMapService.getAddress(context,LatLng(position.latitude,position.longitude));

    setState(() {
      _latLong = new LatLng(position.latitude, position.longitude);
      _cameraPosition = CameraPosition(target: _latLong, zoom: AppConstants.zoomValue);
      if (_googleMapController != null) _googleMapController.animateCamera(CameraUpdate.newCameraPosition(_cameraPosition));
    /*  _address = _placemark[0].name;
      _address = _address + AppConstants.comma + _placemark[0].subLocality;
      _address = _address + AppConstants.comma + _placemark[0].locality;
      _address = _address + AppConstants.comma + _placemark[0].administrativeArea;
      _address = _address + AppConstants.comma + _placemark[0].postalCode;
      _address = _address + AppConstants.comma + _placemark[0].country;*/
    //  _searchTextController.text = _address;
      appLogs(_searchTextController.toString());
      _markers.add(Marker(
          markerId: MarkerId("a"),
          draggable: true,
          position: _latLong,
          infoWindow: InfoWindow(title: _placemark[0].locality),
          onDragEnd: (_currentLatLng) {
            _latLong = _currentLatLng;
          }));
    });
  }
}
