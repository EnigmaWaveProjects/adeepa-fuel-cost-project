import 'package:fuelcost/pages/home_page.dart';

enum PetrolSubType { octane92, octane95 }

enum DieselSubType { superDiesel, normalDiesel }

class FuelInfo {
  final PetrolFuelInfo petrolFuelInfo;
  final DieselFuelInfo dieselFuelInfo;
  FuelInfo({
    required this.petrolFuelInfo,
    required this.dieselFuelInfo,
  });
}

class PetrolFuelInfo {
  final FuelType fuelType;
  final double price92;
  final double price95;
  PetrolFuelInfo({
    required this.fuelType,
    required this.price92,
    required this.price95,
  });
}

class DieselFuelInfo {
  final FuelType fuelType;
  final double superDieselPrice;
  final double dieselPrice;
  DieselFuelInfo({
    required this.fuelType,
    required this.superDieselPrice,
    required this.dieselPrice,
  });
}
