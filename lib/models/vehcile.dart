class Vehicle {
  final String model;
  final double fuelEfficiency;

  Vehicle({required this.model, required this.fuelEfficiency});
}

class VehicleCategory {
  final String name;
  final List<Vehicle> vehicles;

  VehicleCategory({required this.name, required this.vehicles});
}
