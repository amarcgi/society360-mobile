import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PublicBookingsView extends StatelessWidget {
  const PublicBookingsView({super.key});

  @override
  Widget build(BuildContext context) {
    // This data would eventually come from your server
    final List<Map<String, String>> publicBookings = [
      {"user": "Apt 201 - Sarah", "amenity": "Gymnasium", "time": "30 Jun, 06:00 - 07:00"},
      {"user": "Apt 405 - Rahul", "amenity": "Badminton", "time": "01 Jul, 17:00 - 18:00"},
    ];

    return ListView.builder(
      padding: const EdgeInsets.only(top: 10),
      itemCount: publicBookings.length,
      itemBuilder: (context, index) {
        final booking = publicBookings[index];
        return PublicBookingCard(
          residentName: booking["user"]!,
          amenityName: booking["amenity"]!,
          dateTime: booking["time"]!,
        );
      },
    );
  }
}

class PublicBookingCard extends StatelessWidget {
  final String residentName;
  final String amenityName;
  final String dateTime;

  const PublicBookingCard({
    super.key,
    required this.residentName,
    required this.amenityName,
    required this.dateTime
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blueGrey.shade100,
          child: const Icon(Icons.person, color: Colors.blueGrey),
        ),
        title: Text(residentName, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("$amenityName\n$dateTime"),
        isThreeLine: true,
      ),
    );
  }
}