/*
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:society360_app/core/router/app_router.dart';
class VisitorManagementScreen extends StatelessWidget {
  const VisitorManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: const Color(0xFFF9F9F7),
      */
/*appBar: AppBar(
        backgroundColor: const Color(0xFF0D2C54),
        title: const Text('Visitor Management', style: TextStyle(color: Colors.white, fontSize: 18)),
        leading: context.canPop()
            ? IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ): null,
        actions: [
          IconButton(icon: const Icon(Icons.help_outline, color: Colors.white), onPressed: () {}),
        ],
      ),*//*


      appBar: AppBar(
        //backgroundColor: const Color(0xFF0D2C54),
        title: const Text('Visitor Management'),
        // Force back button even if framework thinks there is no stack history
        leading: context.canPop()
            ? IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        )
            : null,
        actions: [
          IconButton(icon: const Icon(Icons.help_outline), onPressed: () {}),
        ],
      ),

      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMetricsRow(),
                const SizedBox(height: 16),
                _buildTimelineTabs(),
                const SizedBox(height: 16),
                _buildSearchBar(),
                const SizedBox(height: 16),
                _buildStatusFilterChips(),
                const SizedBox(height: 24),
                _buildSectionHeader('CURRENTLY INSIDE'),
                _buildVisitorTile('Rajesh Kumar', 'Plumber • Inside since 10:30 AM', 'Inside', Colors.green),
                _buildVisitorTile('Priya Sharma', 'Guest • Inside since 11:15 AM', 'Inside', Colors.green),
                const SizedBox(height: 16),
                _buildSectionHeader('EXPECTED OUT'),
                _buildVisitorTile('Delivery Vikas', 'Delivery • Expected', '10-15 Min', Colors.orange),
                const SizedBox(height: 80), // Spacer for floating CTA
              ],
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D2C54),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => context.push(AppRouter.addVisitor),
              icon: const Icon(Icons.add),
              label: const Text('Add Visitor', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMetricsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildMetricBox('5', 'Today'),
        _buildMetricBox('2', 'Inside'),
        _buildMetricBox('2', 'Expected'),
      ],
    );
  }

  Widget _buildMetricBox(String count, String label) {
    return Container(
      width: 105,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(color: const Color(0xFFF1F3F6), borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Text(count, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0D2C54))),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildTimelineTabs() {
    return Row(
      children: [
        Expanded(child: _buildTabItem('Today', isActive: true)),
        Expanded(child: _buildTabItem('Expected')),
        Expanded(child: _buildTabItem('History')),
      ],
    );
  }

  Widget _buildTabItem(String title, {bool isActive = false}) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: isActive ? Border.all(color: Colors.grey.withOpacity(0.2)) : null,
      ),
      child: Text(title, style: TextStyle(fontWeight: isActive ? FontWeight.bold : FontWeight.normal)),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search visitors...',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildStatusFilterChips() {
    final chips = ['All', 'Inside', 'Checked out', 'Canceled'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: chips.map((label) {
        final isAll = label == 'All';
        return ChoiceChip(
          label: Text(label, style: TextStyle(color: isAll ? Colors.white : Colors.black, fontSize: 12)),
          selected: isAll,
          selectedColor: const Color(0xFF0D2C54),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          onSelected: (_) {},
        );
      }).toList(),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
    );
  }

  Widget _buildVisitorTile(String name, String sub, String badge, Color badgeColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: const Color(0xFFE5E9F0), child: Text(name[0])),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text(sub, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: badgeColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: Text(badge, style: TextStyle(color: badgeColor, fontSize: 12, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }
}*/
