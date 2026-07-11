import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyBookingsView extends StatelessWidget {
  const MyBookingsView({super.key});

  @override
  Widget build(BuildContext context) {
    // This list will eventually come from your API/Database
    final List<Map<String, String>> myBookings = [
      {"name": "Gymnasium", "time": "30 Jun, 07:00 - 08:00", "status": "Confirmed"},
      {"name": "Swimming Pool", "time": "02 Jul, 18:00 - 19:00", "status": "Pending"},
    ];

    return ListView.builder(
      padding: const EdgeInsets.only(top: 10),
      itemCount: myBookings.length,
      itemBuilder: (context, index) {
        final booking = myBookings[index];
        return BookingCard(
          amenityName: booking["name"]!,
          dateTime: booking["time"]!,
          status: booking["status"]!,
        );
      },
    );
  }
}

class BookingCard extends StatelessWidget {
  final String amenityName;
  final String dateTime;
  final String status;

  const BookingCard({super.key, required this.amenityName, required this.dateTime, required this.status});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Color(0xFF00C2CB),
          child: Icon(Icons.calendar_today, color: Colors.white, size: 20),
        ),
        title: Text(amenityName, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(dateTime),
        trailing: Chip(
          label: Text(status, style: const TextStyle(color: Colors.white, fontSize: 11)),
          backgroundColor: status == 'Confirmed' ? Colors.green : Colors.orange,
        ),
      ),
    );
  }
}