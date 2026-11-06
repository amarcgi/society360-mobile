// vehicle_model.dart
class VehicleModel {
  final String vehicleNumber;
  final String vehicleType;  // TWO_WHEELER/FOUR_WHEELER
  final String? model;
  final String? color;
  final String? societyId;
  final String? buildingId;
  final String? residentId;
  final String? vehicleId;
  const VehicleModel({
    required this.vehicleNumber,
    required this.vehicleType,
    this.model,
    this.color,
    this.societyId,
    this.buildingId,
    this.residentId,
    this.vehicleId,
  });

  Map<String, dynamic> toJson() => {
    'vehicleNumber': vehicleNumber,
    'vehicleType':   vehicleType,
    'model':  model,
    'color': color,
    'societyId': societyId,
    'buildingId': buildingId,
    'residentId': residentId,
    'vehicleId': vehicleId,
  };

  static VehicleModel fromJson(Map<String, dynamic> map) {
    return VehicleModel(
      vehicleNumber: map['vehicleNumber'],
      vehicleType:   map['vehicleType'],
      model:         map['model'],
      color:         map['color'],
      societyId:     map['societyId'],
      buildingId:    map['buildingId'],
      residentId:    map['residentId'],
      vehicleId:     map['vehicleId'],
    );
  }

}
