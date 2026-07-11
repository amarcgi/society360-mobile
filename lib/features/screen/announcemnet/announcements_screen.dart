import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:society360_app/core/router/app_router.dart';

import '../../../core/shared/widgets/app_bar.dart';
import 'model/announcement.dart';

class AnnouncementsScreen extends StatefulWidget {
  const AnnouncementsScreen({super.key});

  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  // 1. Placeholder for your API data
  List<Announcement> _announcements = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAnnouncements();
  }

  // 2. Logic to fetch from server
  Future<void> _fetchAnnouncements() async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 2));

    // After fetching, update state
    setState(() {
      _announcements = [
        Announcement(title: "Society Maintenance Work", description: "Scheduled power shutdown...", postedBy: "Society Office", date: "June 20, 2024", type: "Urgent"),
        Announcement(title: "Annual Community Picnic!", description: "Join us at Lakeside Park...", postedBy: "Events Committee", date: "June 18, 2024", type: "Event"),
      ];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F0),
      appBar: CustomAppBars.customAppBar(
        context: context,
        title: 'Announcements',
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        padding: const EdgeInsets.only(top: 10),
        itemCount: _announcements.length,
        itemBuilder: (context, index) => AnnouncementCard(announcement: _announcements[index]),
      ),
    );
  }
}

class AnnouncementCard extends StatelessWidget {
  final Announcement announcement;
  const AnnouncementCard({super.key, required this.announcement});

  Color _getTypeColor() {
    switch (announcement.type.toLowerCase()) {
      case 'urgent': return Colors.red;
      case 'event': return Colors.teal;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: _getTypeColor(), width: 6)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(announcement.type.toUpperCase(), style: TextStyle(color: _getTypeColor(), fontWeight: FontWeight.w500, fontSize: 20,fontFamily: 'Arial')),
          const SizedBox(height: 5),
          Text(announcement.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Text(announcement.description, style: TextStyle(color: Colors.grey.shade700)),
          const SizedBox(height: 12),
          InkWell(
            onTap: () {
              context.push(AppRouter.announcementDetailScreen, extra: announcement);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Posted by: ${announcement.postedBy} | ${announcement.date}", style: const TextStyle(fontSize: 11, color: Colors.grey)),
                const Text("Read More >", style: TextStyle(color: Color(0xFF00C2CB), fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}