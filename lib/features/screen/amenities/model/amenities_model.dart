import 'package:flutter/cupertino.dart';

class Amenity {
  final String name;
  final String status; // 'Open', 'Closed', 'Available'
  final IconData icon;
  final bool isAvailable;
  final String? subStatus; // For maintenance messages

  Amenity({required this.name, required this.status, required this.icon, required this.isAvailable, this.subStatus});
}