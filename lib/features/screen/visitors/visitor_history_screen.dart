import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart'; // Make sure to add intl to your pubspec.yaml

import '../../../core/router/app_router.dart';
import 'model/visitor_history_model.dart';

class VisitorHistoryScreen extends StatefulWidget {
  const VisitorHistoryScreen({super.key});

  @override
  State<VisitorHistoryScreen> createState() => _VisitorHistoryScreenState();
}

class _VisitorHistoryScreenState extends State<VisitorHistoryScreen> {
  // Mock Dynamic Data List (This would typically come from your Bloc state)
  final List<VisitorHistoryModel> _allVisitors = [
    VisitorHistoryModel(
      name: 'Rakesh Kumar',
      logDetails: 'Plumber • Checked out 01:20 PM',
      state: 'Out',
      dateTime: DateTime(2026, 5, 28),
    ),
    VisitorHistoryModel(
      name: 'Priya Sharma',
      logDetails: 'Guest • Checked out 04:00 PM',
      state: 'Out',
      dateTime: DateTime(2026, 5, 28),
    ),
    VisitorHistoryModel(
      name: 'Amitabh Mohanty',
      logDetails: 'Delivery • Checked out 11:15 AM',
      state: 'Out',
      dateTime: DateTime(2026, 5, 27),
    ),
    VisitorHistoryModel(
      name: 'Mohan Joshi',
      logDetails: 'Maid Staff • Checked out 06:00 PM',
      state: 'Out',
      dateTime: DateTime(2026, 5, 27),
    ),
  ];

  DateTimeRange? _selectedDateRange;
  String _searchQuery = '';

  // Function to trigger native Date Range Picker
  Future<void> _pickDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      initialDateRange: _selectedDateRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF0D2C54), // Header background color
              onPrimary: Colors.white,
              onSurface: Color(0xFF0D2C54),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
      });
    }
  }

  // Clear date filters
  void _clearDateFilter() {
    setState(() {
      _selectedDateRange = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    // --- Dynamic Filtering Logic ---
    List<VisitorHistoryModel> filteredVisitors = _allVisitors.where((visitor) {
      // 1. Text Search Filter
      final matchesSearch = visitor.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          visitor.logDetails.toLowerCase().contains(_searchQuery.toLowerCase());

      // 2. Date Range Filter
      if (_selectedDateRange != null) {
        final start = _selectedDateRange!.start.subtract(const Duration(days: 1));
        final end = _selectedDateRange!.end.add(const Duration(days: 1));
        final matchesDate = visitor.dateTime.isAfter(start) && visitor.dateTime.isBefore(end);
        return matchesSearch && matchesDate;
      }

      return matchesSearch;
    }).toList();

    // Sort by date descending (Newest dates first)
    filteredVisitors.sort((a, b) => b.dateTime.compareTo(a.dateTime));

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D2C54),
        title: const Text('Visitor History', style: TextStyle(color: Colors.white, fontSize: 18)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go(AppRouter.addVisitor),
        ),
      ),
      body: Column(
        children: [
          // Search & Date Filter Header Panel
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Search by name...',
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Date Picker Trigger Button
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.date_range,
                          color: _selectedDateRange != null ? Colors.green : const Color(0xFF0D2C54),
                        ),
                        onPressed: _pickDateRange,
                      ),
                    ),
                  ],
                ),
                // Display active date range filter chips
                if (_selectedDateRange != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      InputChip(
                        label: Text(
                          '${DateFormat('dd MMM').format(_selectedDateRange!.start)} - ${DateFormat('dd MMM').format(_selectedDateRange!.end)}',
                          style: const TextStyle(fontSize: 12),
                        ),
                        onDeleted: _clearDateFilter,
                        deleteIconColor: Colors.redAccent,
                        backgroundColor: Colors.white,
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          // --- Dynamic ListView Render Engine ---
          Expanded(
            child: filteredVisitors.isEmpty
                ? const Center(child: Text('No visitor records match your criteria.'))
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: filteredVisitors.length,
              itemBuilder: (context, index) {
                final visitor = filteredVisitors[index];

                bool showHeader = index == 0 ||
                    _getFormattedDate(visitor.dateTime) !=
                        _getFormattedDate(filteredVisitors[index - 1].dateTime);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showHeader) _buildDateHeader(_getFormattedDate(visitor.dateTime)),
                    // Passed 'context' and the whole 'visitor' object here
                    _buildHistoryItem(context, visitor),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getFormattedDate(DateTime dateTime) {
    return DateFormat('dd MMMM yyyy').format(dateTime).toUpperCase();
  }

  Widget _buildDateHeader(String date) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      //style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey),
      child: Text(date),
    );
  }

  Widget _buildHistoryItem(BuildContext context, VisitorHistoryModel visitor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Material(
        color: Colors.transparent, // Keeps container color visible
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            // --- NAVIGATION TRIGGER ---
            // Option A: Passing the object via state extra
            context.go(AppRouter.visitorDetail, extra: visitor);

            // Option B: If your path uses IDs (e.g., '/visitor/123')
            // context.go('${AppRouter.visitorDetail}/${visitor.name}');
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0), // Padding moved inside InkWell for better touch target area
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(visitor.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(visitor.logDetails, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      visitor.state,
                      style: const TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold),
                    ),
                    const Icon(Icons.chevron_right, color: Colors.grey, size: 16),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}