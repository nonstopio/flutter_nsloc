import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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

class MyMapState extends State {
  LatLng _latLong = LatLng(0, 0);
  CameraPosition _cameraPosition;
  GoogleMapController _controller;
  String address = "";

  Set<Marker> _markers = {};
  TextEditingController _locationController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cameraPosition = CameraPosition(target: LatLng(0, 0), zoom: 10.0);
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
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
                  _controller = (controller);
                  _controller.animateCamera(CameraUpdate.newCameraPosition(_cameraPosition));
                },
                markers: _markers,
              ),
              Column(
                children: <Widget>[
                  TextField(
                    controller: _locationController,
                  ),
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(Sizes.s20),
                    child: Text(address),
                  ),
                ],
              ),
            ],
          )),
    );
  }

  Future getCurrentLocation() async {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(position.latitude);

    List _placemark = await Geolocator().placemarkFromCoordinates(position.latitude, position.longitude);

    setState(() {
      _latLong = new LatLng(position.latitude, position.longitude);
      _cameraPosition = CameraPosition(target: _latLong, zoom: 10.0);
      if (_controller != null) _controller.animateCamera(CameraUpdate.newCameraPosition(_cameraPosition));
      address = _placemark[0].name;
      address = address + "," + _placemark[0].subLocality;
      address = address + "," + _placemark[0].locality;
      address = address + "," + _placemark[0].country;
      address = address + "," + _placemark[0].postalCode;
      _locationController.text = address;
      appLogs(_locationController.toString());
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
