import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core.dart';

class LocationUtils {
  static Future<bool?> checkGPSPermition(BuildContext context) async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      DefaultDialog(
        title: "GPS off",
        content:
            "GPS Anda tidak aktif\nsilahkan aktifkan gps anda terlebih dahulu",
        icon: Icons.location_off,
        color: Colors.red,
      ).show(context);
      return null;
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        DefaultDialog(
          title: "Izin",
          content: "Silahkan Izin Kan GPS",
        ).showWarning(context);
        return null;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      DefaultDialog(
        title: "Izin",
        content: "Silahkan Izin Kan GPS Di Menu Pengaturan",
      ).showWarning(context);
      return null;
    }
    return true;
  }

  static Future<Position?> getCurrentLocation(BuildContext context) async {
    final checker = await checkGPSPermition(context);
    if (checker == null) return null;
    return await Geolocator.getCurrentPosition();
  }
}
