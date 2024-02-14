import 'package:flutter/material.dart' hide BorderRadius;
import 'package:fuelcost/pages/location/map.dart';

import '../../models/selected_location_mode.dart';

class LocationPickerView extends StatefulWidget {
  final Function(SelectedLocation) onSelect;
  const LocationPickerView({super.key, required this.onSelect});

  @override
  State<LocationPickerView> createState() => _LocationPickerViewState();
}

class _LocationPickerViewState extends State<LocationPickerView> {
  SelectedLocation? selectedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: selectedLocation != null
            ? FloatingActionButton(
                onPressed: () {
                  Navigator.pop(context, selectedLocation);
                },
                child: const Icon(Icons.done),
              )
            : null,
        body: MapWidget(
          onSelect: (val) {
            widget.onSelect(val);
          },
        ));
  }
}
