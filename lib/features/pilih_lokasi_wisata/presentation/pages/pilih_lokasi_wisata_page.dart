import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wlotim/core/core.dart';
import 'package:wlotim/core/src/utils/src/location/location_util.dart';

class PilihLokasiWisataPage extends StatefulWidget {
  const PilihLokasiWisataPage({Key? key}) : super(key: key);

  @override
  State<PilihLokasiWisataPage> createState() => _PilihLokasiWisataPageState();
}

class _PilihLokasiWisataPageState extends State<PilihLokasiWisataPage> {
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
    await mapsController!.animateCamera(
        CameraUpdate.newLatLng(LatLng(location.latitude, location.longitude)));
  }

  void addWisataMarker(LatLng position) {
    markers.clear();
    markers.add(
      Marker(
        markerId: const MarkerId("Wisata"),
        position: position,
        infoWindow: const InfoWindow(
          title: "Wisata",
        ),
      ),
    );
    if (mapsController != null) {
      mapsController!.animateCamera(CameraUpdate.newLatLng(position));
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
            onTap: (argument) {
              addWisataMarker(argument);
              state.call(
                () {},
              );
            },
            onMapCreated: (GoogleMapController controller) async {
              if (mapsCompleter.isCompleted) {
                mapsCompleter.complete(controller);
                mapsController = await mapsCompleter.future;
              } else {
                mapsController = controller;
              }
              await toCurrentLocation(context);
            },
          );
        }),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
              width: MediaQuery.of(context).size.width * .9,
              child: ElevatedButton(
                  onPressed: () {
                    if (markers.isEmpty) {
                      DefaultDialog(
                        autoCloseDuration: const Duration(seconds: 3),
                        title: "Invalid",
                        content: "Anda belum memilih lokasi wisata",
                      ).showWarning(context);
                      return;
                    }
                    Navigator.pop(context, markers.first.position);
                  },
                  child: const Text("Konfirmasi")))
        ],
      ),
    );
  }
}
