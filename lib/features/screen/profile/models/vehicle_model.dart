// vehicle_model.dart
class VehicleModel {
  final String vehicleNumber;
  final String vehicleType;  // TWO_WHEELER/FOUR_WHEELER
  final String? make;
  final String? color;

  const VehicleModel({
    required this.vehicleNumber,
    required this.vehicleType,
    this.make,
    this.color,
  });

  Map<String, dynamic> toJson() => {
    'vehicleNumber': vehicleNumber,
    'vehicleType':   vehicleType,
    'make':  make,
    'color': color,
  };
}
