import 'package:flutter/material.dart';
import 'package:society360_app/features/screen/amenities/public_bookings_view.dart';
import '../../../core/shared/widgets/app_bar.dart';
import 'amenities_booking_helper.dart';
import 'model/amenities_model.dart';
import 'model/my_booking.dart'; // Ensure your Amenity model is imported


class AmenitiesScreen extends StatelessWidget {
  const AmenitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFFF2F2F0),
        appBar: CustomAppBars.customAppBar(context: context, title: 'Amenities',
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            indicatorColor: Colors.tealAccent,
            labelStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            unselectedLabelStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            tabs: const [
              Tab(text: "Browse"),
              Tab(text: "My Bookings"),
              Tab(text: "Public"),
            ],
          ),
        ),

        body: const TabBarView(
          children: [
            BrowseAmenitiesView(),
            MyBookingsView(), // <--- Updated here
            PublicBookingsView(), //
          ],
        ),
      ),
    );
  }
}

class BrowseAmenitiesView extends StatelessWidget {
  const BrowseAmenitiesView({super.key});

  @override
  Widget build(BuildContext context) {
    // Replace with your actual dynamic list or API service
    final List<Amenity> _amenities = List.generate(8, (index) =>
        Amenity(name: "Gymnasium", status: "Open", icon: Icons.fitness_center, isAvailable: true));

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search gym, pool, club house...',
              prefixIcon: const Icon(Icons.search, color: Color(0xFF00C2CB)),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.85,
            ),
            itemCount: _amenities.length,
            itemBuilder: (context, index) => AmenityCard(amenity: _amenities[index]),
          ),
        ),
      ],
    );
  }
}

class AmenityCard extends StatelessWidget {
  final Amenity amenity;
  const AmenityCard({super.key, required this.amenity});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: amenity.isAvailable ? Colors.white : const Color(0xFF0D2C54),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        children: [
          Icon(amenity.icon, size: 48, color: const Color(0xFF00C2CB)),
          const SizedBox(height: 12),
          Text(amenity.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: amenity.isAvailable ? Colors.black : Colors.white)),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: amenity.isAvailable ? () => AmenitiesBookingHelper.showBookingModal(context, amenity.name) : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00C2CB),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("Book", style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}

