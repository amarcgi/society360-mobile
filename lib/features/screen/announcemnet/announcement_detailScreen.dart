import 'package:flutter/material.dart';

import '../../../core/shared/widgets/app_bar.dart';
import 'model/announcement.dart';

class AnnouncementDetailScreen extends StatefulWidget {
  final Announcement announcement;

  const AnnouncementDetailScreen({super.key, required this.announcement});

  @override
  State<AnnouncementDetailScreen> createState() => _AnnouncementDetailScreenState();
}

class _AnnouncementDetailScreenState extends State<AnnouncementDetailScreen> {
  // You can add state variables here, e.g., bool isAcknowledged = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBars.customAppBar(
        context: context,
        title: 'Announcements Details',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Type Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blueGrey.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                widget.announcement.type.toUpperCase(),
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey),
              ),
            ),
            const SizedBox(height: 15),

            // Title
            Text(
              widget.announcement.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Meta Info
            Row(
              children: [
                const Icon(Icons.person, size: 16, color: Colors.grey),
                const SizedBox(width: 5),
                Text(widget.announcement.postedBy, style: const TextStyle(color: Colors.grey)),
                const SizedBox(width: 15),
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 5),
                Text(widget.announcement.date, style: const TextStyle(color: Colors.grey)),
              ],
            ),
            const Divider(height: 30),

            // Full Description
            Text(
              widget.announcement.description,
              style: const TextStyle(fontSize: 16, height: 1.5, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}