import 'package:google_maps_flutter/google_maps_flutter.dart';

class SelectedLocation {
  final LatLng latLng;
  final String address;
  SelectedLocation({
    required this.latLng,
    required this.address,
  });
}
