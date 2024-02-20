import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fuelcost/models/fuel_info.dart';
import 'package:fuelcost/models/vehcile.dart';
import 'package:fuelcost/pages/location/location_select.dart';
import 'package:fuelcost/pages/result_page.dart';
import 'package:fuelcost/repositories/vehicle_repository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

enum FuelType { petrol, diesel }

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool vehicleFetching = false;
  @override
  void initState() {
    _controller = TextEditingController();
    getVehicles();
    super.initState();
  }

  getVehicles() async {
    setState(() {
      vehicleFetching = true;
    });

    var data = await VehicleRepository.getVehicles();
    setState(() {
      vehicleFetching = false;
      vehicleCategories = data;
      selectedCategory = data.first;
    });
  }

  int _currentIndex = 0;
  FuelType selectedFuelType = FuelType.petrol;

  PetrolSubType selectedPetrolFuelSubType = PetrolSubType.octane92;
  DieselSubType selectedDieselFuelSubType = DieselSubType.normalDiesel;

  String selectedVehicleType = 'Car';
  double distance = 0.0;
  LatLng? _fromLocation;
  LatLng? _toLocation;
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  String? _routePolyline; // Store the polyline of the route
  double fuelCost = 0.0;
  double totalCost = 0.0;

  FuelInfo fuelCostData = FuelInfo(
    petrolFuelInfo: PetrolFuelInfo(
      fuelType: FuelType.petrol,
      price92: 350,
      price95: 370,
    ),
    dieselFuelInfo: DieselFuelInfo(
      fuelType: FuelType.diesel,
      superDieselPrice: 360,
      dieselPrice: 310,
    ),
  );

  VehicleCategory? selectedCategory;

  late List<VehicleCategory> vehicleCategories = [];

  String selectedVehicleModel = 'Toyota Corolla'; // Default vehicle model
  Vehicle? selectedVehicle; // Default vehicle model

  // Map<String, Map<String, double>> vehicleModels = {
  //   'Car': {
  //     'Toyota Corolla': 14,
  //     'Nissan Sunny': 14,
  //     'Toyota Premio': 15,
  //     'Honda Civic': 10,
  //     'BMW 318i': 12,
  //     'Bajaj Pulsar': 45,
  //     'TVS Metro': 65,
  //     'Bajaj CT100': 75,
  //     'Honda CD200': 30,
  //     'Honda CD125': 40,
  //     'Isuzu Canter': 6,
  //     'Leyland Lorry 9': 5,
  //     'Leyland Bus': 5,
  //     'Nissan Caravan': 11,
  //     'Toyota Hiace': 10,
  //     'Toyota Prado': 8,
  //     'Nissan Patrol': 7,
  //     'Mitsubishi Montero': 8,
  //   },
  //   'Bike': {
  //     'Toyota Corolla': 14,
  //     'Nissan Sunny': 14,
  //     'Toyota Premio': 15,
  //     'Honda Civic': 10,
  //     'BMW 318i': 12,
  //     'Bajaj Pulsar': 45,
  //     'TVS Metro': 65,
  //     'Bajaj CT100': 75,
  //     'Honda CD200': 30,
  //     'Honda CD125': 40,
  //     'Isuzu Canter': 6,
  //     'Leyland Lorry 9': 5,
  //     'Leyland Bus': 5,
  //     'Nissan Caravan': 11,
  //     'Toyota Hiace': 10,
  //     'Toyota Prado': 8,
  //     'Nissan Patrol': 7,
  //     'Mitsubishi Montero': 8,
  //   },
  //   'Heavy': {
  //     'Toyota Corolla': 14,
  //     'Nissan Sunny': 14,
  //     'Toyota Premio': 15,
  //     'Honda Civic': 10,
  //     'BMW 318i': 12,
  //     'Bajaj Pulsar': 45,
  //     'TVS Metro': 65,
  //     'Bajaj CT100': 75,
  //     'Honda CD200': 30,
  //     'Honda CD125': 40,
  //     'Isuzu Canter': 6,
  //     'Leyland Lorry 9': 5,
  //     'Leyland Bus': 5,
  //     'Nissan Caravan': 11,
  //     'Toyota Hiace': 10,
  //     'Toyota Prado': 8,
  //     'Nissan Patrol': 7,
  //     'Mitsubishi Montero': 8,
  //   },
  //   'Van': {
  //     'Toyota Corolla': 14,
  //     'Nissan Sunny': 14,
  //     'Toyota Premio': 15,
  //     'Honda Civic': 10,
  //     'BMW 318i': 12,
  //     'Bajaj Pulsar': 45,
  //     'TVS Metro': 65,
  //     'Bajaj CT100': 75,
  //     'Honda CD200': 30,
  //     'Honda CD125': 40,
  //     'Isuzu Canter': 6,
  //     'Leyland Lorry 9': 5,
  //     'Leyland Bus': 5,
  //     'Nissan Caravan': 11,
  //     'Toyota Hiace': 10,
  //     'Toyota Prado': 8,
  //     'Nissan Patrol': 7,
  //     'Mitsubishi Montero': 8,
  //   },
  //   'Suv': {
  //     'Toyota Corolla': 14,
  //     'Nissan Sunny': 14,
  //     'Toyota Premio': 15,
  //     'Honda Civic': 10,
  //     'BMW 318i': 12,
  //     'Bajaj Pulsar': 45,
  //     'TVS Metro': 65,
  //     'Bajaj CT100': 75,
  //     'Honda CD200': 30,
  //     'Honda CD125': 40,
  //     'Isuzu Canter': 6,
  //     'Leyland Lorry 9': 5,
  //     'Leyland Bus': 5,
  //     'Nissan Caravan': 11,
  //     'Toyota Hiace': 10,
  //     'Toyota Prado': 8,
  //     'Nissan Patrol': 7,
  //     'Mitsubishi Montero': 8,
  //   },
  // };

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _updateMarkers();
    _updateCamera();
  }

  void _updateMarkers() {
    _markers.clear();
    if (_fromLocation != null) {
      _markers.add(Marker(
        markerId: const MarkerId('FromLocation'),
        position: _fromLocation!,
        infoWindow: const InfoWindow(title: 'From Location'),
      ));
    }
    if (_toLocation != null) {
      _markers.add(Marker(
        markerId: const MarkerId('ToLocation'),
        position: _toLocation!,
        infoWindow: const InfoWindow(title: 'To Location'),
      ));
    }
  }

  void _updateCamera() {
    if (_fromLocation != null && _toLocation != null) {
      LatLngBounds bounds = LatLngBounds(
        southwest: _fromLocation!,
        northeast: _toLocation!,
      );
      _mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50.0));
    }
  }

  Future<void> _calculateAndDisplayRoute() async {
    if (_fromLocation != null && _toLocation != null) {
      String apiKey = dotenv.get("GOOGLE_API_KEY");
      final String url =
          'https://maps.googleapis.com/maps/api/directions/json?origin=${_fromLocation!.latitude},${_toLocation!.longitude}&destination=${_fromLocation!.latitude},${_toLocation!.longitude}&mode=driving&key=$apiKey';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final points = data['routes'][0]['overview_polyline']['points'];
        setState(() {
          _routePolyline = points;
        });
      } else {
        print('Error fetching route data');
      }
      // }
    }
  }

  void _calculateAndDisplayCost() {
    if (selectedVehicle == null ||
        (_fromLocation == null && _toLocation == null)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Please select vehicle, and destination locations")));
    }
    // if (_fromLocation != null && _toLocation != null) {
    distance = calculateDistance(_fromLocation!, _toLocation!);
    fuelCost = selectedFuelType == FuelType.diesel
        ? selectedDieselFuelSubType == DieselSubType.normalDiesel
            ? fuelCostData.dieselFuelInfo.dieselPrice
            : fuelCostData.dieselFuelInfo.superDieselPrice
        : selectedPetrolFuelSubType == PetrolSubType.octane92
            ? fuelCostData.petrolFuelInfo.price92
            : fuelCostData.petrolFuelInfo.price95;

    double efficiency = selectedVehicle!.fuelEfficiency;
    totalCost = (distance / efficiency) * fuelCost;
    distance = double.parse(distance.toStringAsFixed(2));
    fuelCost = double.parse(fuelCost.toStringAsFixed(2));
    totalCost = double.parse(totalCost.toStringAsFixed(2));

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultPage(
          distance: distance,
          fuelCost: fuelCost,
          totalCost: totalCost,
        ),
      ),
    );
  }

  Key typeAheadKey = UniqueKey(); // Create a unique key for TypeAheadField

  late TextEditingController _controller;

  double calculateDistance(LatLng from, LatLng to) {
    const double earthRadius = 6371.0; // Radius of the Earth in kilometers

    double fromLatRadians = from.latitude * (pi / 180.0);
    double toLatRadians = to.latitude * (pi / 180.0);
    double latDiffRadians = (to.latitude - from.latitude) * (pi / 180.0);
    double lonDiffRadians = (to.longitude - from.longitude) * (pi / 180.0);

    double a = pow(sin(latDiffRadians / 2), 2) +
        cos(fromLatRadians) *
            cos(toLatRadians) *
            pow(sin(lonDiffRadians / 2), 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    double distance = earthRadius * c; // Distance in kilometers
    return distance;
  }

  List<LatLng> decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0;
    int len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return points;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Fuel Cost Calculator'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: IconButton(
              onPressed: () {
                // Navigate to profile page
                Navigator.pushNamed(context, '/profile');
              },
              icon: const Icon(Icons.person),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Row(
                // Wrap the child elements in a Column
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const BackButtonIcon(),
                      color: Colors.white),
                  const Text(
                    'Fuel Cost',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: const Text('Sign Out'),
              onTap: () {
                // Perform sign-out logic and navigate to sign-in page
                Navigator.pushReplacementNamed(context, '/signin');
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: vehicleFetching
            ? CupertinoActivityIndicator()
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 50),
                      // Padding(
                      //   padding: const EdgeInsets.all(30.0),
                      //   child: Image.asset('assets/img.jpeg'),
                      // ),
                      TypeAheadField<Vehicle>(
                        key: typeAheadKey,
                        hideOnEmpty: true,
                        suggestionsCallback: (search) {
                          return selectedCategory!.vehicles
                              .where((vehicle) =>
                                  vehicle.model.toLowerCase().contains(search))
                              .toList();
                        },
                        builder: (context, _, focusNode) {
                          return TextField(
                            controller: _controller,
                            focusNode: focusNode,
                            decoration: InputDecoration(
                                // enabled: false,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                labelText: 'Vehicle'),
                          );
                        },
                        itemBuilder: (context, vehicle) {
                          return ListTile(
                            title: Text(vehicle.model),
                            subtitle: Text(vehicle.fuelEfficiency.toString()),
                          );
                        },
                        onSelected: (vehicle) {
                          setState(() {
                            selectedVehicle = vehicle;
                            _controller.text = vehicle.model;
                          });
                        },
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: vehicleCategories
                              .map(
                                (e) => Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedCategory = e;
                                        typeAheadKey = UniqueKey();
                                      });
                                    },
                                    child: Chip(
                                      backgroundColor: selectedCategory == e
                                          ? Colors.blue
                                          : Colors.grey.withOpacity(0.2),
                                      label: Text(
                                        e.name,
                                        style: TextStyle(
                                            color: selectedCategory == e
                                                ? Colors.white
                                                : Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Divider(),
                      const SizedBox(height: 20),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 90,
                                height: 40,
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      selectedFuelType = FuelType.petrol;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        selectedFuelType == FuelType.petrol
                                            ? Colors.blue
                                            : Colors.grey,
                                  ),
                                  child: const Text(
                                    'Petrol',
                                    style: TextStyle(
                                        fontFamily: 'DM Sans',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 30),
                              SizedBox(
                                width: 90,
                                height: 40,
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      selectedFuelType = FuelType.diesel;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        selectedFuelType == FuelType.diesel
                                            ? Colors.blue
                                            : Colors.grey,
                                  ),
                                  child: const Text(
                                    'Diesel',
                                    style: TextStyle(
                                        fontFamily: 'DM Sans',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            child: selectedFuelType == FuelType.diesel
                                ? DropdownButton<DieselSubType>(
                                    value: selectedDieselFuelSubType,
                                    onChanged: (DieselSubType? newValue) {
                                      setState(() {
                                        selectedDieselFuelSubType = newValue!;
                                      });
                                    },
                                    items: DieselSubType.values
                                        .map<DropdownMenuItem<DieselSubType>>(
                                      (DieselSubType value) {
                                        return DropdownMenuItem<DieselSubType>(
                                          value: value,
                                          child: Text(
                                              value
                                                  .toString()
                                                  .split(".")[1]
                                                  .toUpperCase(),
                                              style: const TextStyle(
                                                  fontFamily: 'DM Sans',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16)),
                                        );
                                      },
                                    ).toList(),
                                  )
                                : DropdownButton<PetrolSubType>(
                                    value: selectedPetrolFuelSubType,
                                    onChanged: (PetrolSubType? newValue) {
                                      setState(() {
                                        selectedPetrolFuelSubType = newValue!;
                                      });
                                    },
                                    items: PetrolSubType.values
                                        .map<DropdownMenuItem<PetrolSubType>>(
                                      (PetrolSubType value) {
                                        return DropdownMenuItem<PetrolSubType>(
                                          value: value,
                                          child: Text(
                                              value
                                                  .toString()
                                                  .split(".")[1]
                                                  .toUpperCase(),
                                              style: const TextStyle(
                                                  fontFamily: 'DM Sans',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16)),
                                        );
                                      },
                                    ).toList(),
                                  ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Divider(),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          // Expanded(
                          //   child: DropdownButton<String>(
                          //     hint: const Text('From Location',
                          //         style: TextStyle(
                          //             fontFamily: 'DM Sans',
                          //             fontWeight: FontWeight.bold,
                          //             fontSize: 16)),
                          //     value: _fromLocation != null
                          //         ? '${_fromLocation!.latitude}, ${_fromLocation!.longitude}'
                          //         : null,
                          //     onChanged: (String? newValue) {
                          //       setState(() {
                          //         if (newValue != null) {
                          //           final parts = newValue.split(', ');
                          //           _fromLocation = LatLng(
                          //             double.parse(parts[0]),
                          //             double.parse(parts[1]),
                          //           );
                          //           _updateMarkers();
                          //           _updateCamera();
                          //         }
                          //       });
                          //     },
                          //     items: cities.map<DropdownMenuItem<String>>(
                          //       (City city) {
                          //         return DropdownMenuItem<String>(
                          //           value: city.coordinates,
                          //           child: Text(city.name,
                          //               style: const TextStyle(
                          //                   fontFamily: 'DM Sans',
                          //                   fontWeight: FontWeight.bold,
                          //                   fontSize: 16)),
                          //         );
                          //       },
                          //     ).toList(),
                          //   ),

                          // ),

                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LocationPickerView(
                                        onSelect: (location) {
                                          if (location != null) {
                                            setState(() {
                                              _fromLocation = location.latLng;
                                            });
                                            UniqueKey key = UniqueKey();
                                            setState(() {
                                              _markers.add(
                                                Marker(
                                                    markerId: MarkerId(
                                                        key.toString()),
                                                    position: location.latLng),
                                              );
                                            });
                                          }
                                        },
                                      ),
                                    ));
                              },
                              child: Row(
                                children: [
                                  const Text('From Location',
                                      style: TextStyle(
                                          fontFamily: 'DM Sans',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                  const SizedBox(width: 5),
                                  SizedBox(
                                    child: _fromLocation != null
                                        ? const Icon(
                                            Icons.done_all_outlined,
                                            color: Colors.green,
                                          )
                                        : null,
                                  )
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(width: 20),
                          Expanded(
                              child: GestureDetector(
                            onTap: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LocationPickerView(
                                      onSelect: (location) {
                                        if (location != null) {
                                          setState(() {
                                            _toLocation = location.latLng;
                                          });
                                          UniqueKey key = UniqueKey();
                                          setState(() {
                                            _markers.add(
                                              Marker(
                                                  markerId:
                                                      MarkerId(key.toString()),
                                                  position: location.latLng),
                                            );
                                          });
                                        }
                                      },
                                    ),
                                  ));
                            },
                            child: Row(
                              children: [
                                const Text(
                                  'To Location',
                                  style: TextStyle(
                                      fontFamily: 'DM Sans',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                const SizedBox(width: 5),
                                SizedBox(
                                  child: _toLocation != null
                                      ? const Icon(
                                          Icons.done_all_outlined,
                                          color: Colors.green,
                                        )
                                      : null,
                                )
                              ],
                            ),
                          ))
                          // Expanded(
                          //   child: DropdownButton<String>(
                          //     hint: const Text('To Location',
                          //         style: TextStyle(
                          //             fontFamily: 'DM Sans',
                          //             fontWeight: FontWeight.bold,
                          //             fontSize: 16)),
                          //     value: _toLocation != null
                          //         ? '${_toLocation!.latitude}, ${_toLocation!.longitude}'
                          //         : null,
                          //     onChanged: (String? newValue) {
                          //       setState(() {
                          //         if (newValue != null) {
                          //           final parts = newValue.split(', ');
                          //           _toLocation = LatLng(
                          //             double.parse(parts[0]),
                          //             double.parse(parts[1]),
                          //           );
                          //           _updateMarkers();
                          //           _updateCamera();
                          //         }
                          //       });
                          //     },
                          //     items: cities.map<DropdownMenuItem<String>>(
                          //       (City city) {
                          //         return DropdownMenuItem<String>(
                          //           value: city.coordinates,
                          //           child: Text(city.name,
                          //               style: const TextStyle(
                          //                   fontFamily: 'DM Sans',
                          //                   fontWeight: FontWeight.bold,
                          //                   fontSize: 16)),
                          //         );
                          //       },
                          //     ).toList(),
                          //   ),
                          // ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Divider(),
                      const SizedBox(height: 10),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //   children: [
                      //     Center(
                      //       child: DropdownButton<String>(
                      //         value: selectedVehicleType,
                      //         onChanged: (String? newValue) {
                      //           setState(() {
                      //             selectedVehicleType = newValue!;
                      //             selectedVehicleModel = vehicleModels[
                      //                     selectedVehicleType]![0]
                      //                 as String; // Reset selected model when type changes
                      //           });
                      //         },
                      //         items: vehicleModels.keys
                      //             .map<DropdownMenuItem<String>>((String value) {
                      //           return DropdownMenuItem<String>(
                      //             value: value,
                      //             child: Center(
                      //               child: SizedBox(
                      //                 width: 100,
                      //                 child: Center(
                      //                   child: Text(value,
                      //                       style: const TextStyle(
                      //                           fontFamily: 'DM Sans',
                      //                           fontWeight: FontWeight.bold,
                      //                           fontSize: 16)),
                      //                 ),
                      //               ),
                      //             ),
                      //           );
                      //         }).toList(),
                      //       ),
                      //     ),
                      //     const SizedBox(width: 20),
                      //     Center(
                      //       child: DropdownButton<String>(
                      //         value: selectedVehicleModel,
                      //         onChanged: (String? newValue) {
                      //           setState(() {
                      //             selectedVehicleModel = newValue!;
                      //           });
                      //         },
                      //         items: vehicleModels[selectedVehicleType]
                      //             ?.keys
                      //             .map<DropdownMenuItem<String>>(
                      //           (String value) {
                      //             return DropdownMenuItem<String>(
                      //               value: value,
                      //               child: Text(value,
                      //                   style: const TextStyle(
                      //                       fontFamily: 'DM Sans',
                      //                       fontWeight: FontWeight.bold,
                      //                       fontSize: 16)),
                      //             );
                      //           },
                      //         ).toList(),
                      //       ),
                      //     ),
                      //   ],
                      // ),

                      SizedBox(
                        height: 200,
                        child: GoogleMap(
                          onMapCreated: _onMapCreated,
                          markers: _markers,
                          polylines: {
                            if (_routePolyline != null)
                              Polyline(
                                polylineId: const PolylineId('route'),
                                points: decodePolyline(_routePolyline!),
                                color: Colors.blue,
                                width: 5,
                              ),
                          },
                          initialCameraPosition: const CameraPosition(
                            target: LatLng(7.0, 80.0),
                            zoom: 7.0,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _calculateAndDisplayCost();
                        },
                        child: const Text('Calculate Route and Fuel Cost'),
                      ),
                    ],
                  ),
                ),
              ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        // Add this section
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          if (_currentIndex == 0) {
            Navigator.pushNamed(context, '/home');
          } else if (_currentIndex == 1) {
            Navigator.pushNamed(context, '/profile');
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  // List<String> getAvailableFuelSubtypes() {
  //   return fuelCostData[selectedFuelType]?.keys.toList() ?? [];
  // }
}
