import 'package:flutter/material.dart'; // Changed from 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fuelcost/models/selected_location_mode.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';

class MapWidget extends StatelessWidget {
  final Function(SelectedLocation) onSelect;
  const MapWidget({Key? key, required this.onSelect})
      : super(key: key); // Corrected constructor

  @override
  Widget build(BuildContext context) {
    LatLng colomboLatLng = LatLng(6.9271, 79.8612);

    return SizedBox(
      child: Container(
        // Wrap MapLocationPicker with Container
        child: PlacePicker(
          apiKey: dotenv.get('GOOGLE_API_KEY'),
          onPlacePicked: (result) {
            onSelect(SelectedLocation(
                latLng: LatLng(result!.geometry!.location.lat,
                    result!.geometry!.location.lng),
                address: result.formattedAddress!));
            Navigator.of(context).pop();
          },
          initialPosition: colomboLatLng,
          useCurrentLocation: true,
          resizeToAvoidBottomInset:
              false, // only works in page mode, less flickery, remove if wrong offsets
        ),
      ),
    );
  }
}
