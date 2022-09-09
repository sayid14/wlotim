import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wlotim/core/src/utils/src/location/location_util.dart';

class MapsWisataPage extends StatefulWidget {
  const MapsWisataPage({Key? key}) : super(key: key);

  @override
  State<MapsWisataPage> createState() => _MapsWisataPageState();
}

class _MapsWisataPageState extends State<MapsWisataPage> {
  List<Map<String, dynamic>> wisataList = [
    {
      "nama": "Air Terjun Jeruk Manis",
      "lat": -8.515177019190377,
      "lng": 116.42404485424161
    },
    {
      "nama": "Jobong Waterpark",
      "lat": -8.672176982650509,
      "lng": 116.5458050254076
    },
    {
      "nama": "Labuhan Haji",
      "lat": -8.674918035472919,
      "lng": 116.57200956466451
    },
    {
      "nama": "Pantai Lungkak",
      "lat": -8.789548751123133,
      "lng": 116.50457965424503
    },
  ];
  CameraPosition initLocation = const CameraPosition(
    target: LatLng(-6.175275063136812, 106.82713133887096),
    zoom: 14.4746,
  );
  Set<Marker> markers = {};
  final Completer<GoogleMapController> mapsCompleter = Completer();
  GoogleMapController? mapsController;
  Future toCurrentLocation(BuildContext context) async {
    final location = await LocationUtils.getCurrentLocation(context);
    if (mapsController == null || location == null) return;
    await mapsController!.moveCamera(
        CameraUpdate.newLatLng(LatLng(location.latitude, location.longitude)));
  }

  void addWisataMarker() {
    for (var wisata in wisataList) {
      markers.add(
        Marker(
          markerId: MarkerId(wisata["nama"]),
          position: LatLng(wisata["lat"], wisata["lng"]),
          infoWindow: InfoWindow(
            title: wisata["nama"],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StatefulBuilder(builder: (context, state) {
          return GoogleMap(
            mapType: MapType.normal,
            compassEnabled: true,
            zoomControlsEnabled: true,
            markers: markers,
            initialCameraPosition: initLocation,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            mapToolbarEnabled: true,
            onMapCreated: (GoogleMapController controller) async {
              if (mapsCompleter.isCompleted) {
                mapsCompleter.complete(controller);
                mapsController = await mapsCompleter.future;
              } else {
                mapsController = controller;
              }
              await toCurrentLocation(context);
              addWisataMarker();
              state.call(
                () {},
              );
            },
          );
        }),
      ),
    );
  }
}
