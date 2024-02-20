import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/vehcile.dart';

class VehicleRepository {
  static Future<List<VehicleCategory>> getVehicles() async {
    try {
      final response =
          await http.get(Uri.https('adeepa-be.vercel.app', '/home'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        List<VehicleCategory> categories = [];

        for (var categoryData in jsonData) {
          String name = categoryData['name'];
          List<dynamic> vehiclesData = categoryData['vehicles'];

          List<Vehicle> vehicles = vehiclesData
              .map((vehicleData) => Vehicle(
                    model: vehicleData['model'],
                    fuelEfficiency: vehicleData['fuelEfficiency'].toDouble(),
                  ))
              .toList();

          categories.add(VehicleCategory(name: name, vehicles: vehicles));
        }

        return categories;
      } else {
        print('Failed to load vehicles: ${response.statusCode}');
        return [];
      }
    } catch (err) {
      print('Error loading vehicles: $err');
      return [];
    }
  }
}
