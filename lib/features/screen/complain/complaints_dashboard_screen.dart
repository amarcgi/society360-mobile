import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:society360_app/core/router/app_router.dart';

import 'model/complaint_enums.dart';
import 'model/complaint_models.dart';

class ComplaintsDashboardScreen extends StatefulWidget {
  const ComplaintsDashboardScreen({super.key});

  @override
  State<ComplaintsDashboardScreen> createState() => _ComplaintsDashboardScreenState();
}

class _ComplaintsDashboardScreenState extends State<ComplaintsDashboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Track active filter state variables
  int? _filterCategoryId;
  ComplaintStatus? _filterStatus;
  String? _filterSubmittedBy; // Options: 'My Flat', 'Building', 'Society'

  // Mirroring backend lookup structures
  final List<Map<String, dynamic>> _categories = [
    {'id': 1, 'name': 'Plumbing'},
    {'id': 2, 'name': 'Electrical'},
    {'id': 3, 'name': 'Lift Maintenance'},
    {'id': 4, 'name': 'Water Provision'},
    {'id': 5, 'name': 'Security'},
  ];

  // Mock records updated with specific flatId maps matching structural selectors
  final List<RaiseComplainResponse> _mockBackendComplaints = [
    RaiseComplainResponse(
      complaintId: 101,
      flatId: 402, // My Flat
      residentId: 99,
      complaintCategoryId: 1,
      title: 'Water Leakage in Kitchen pipeline',
      description: 'Heavy dripping underneath the primary sink area causing storage damage.',
      priority: Priority.HIGH,
      complaintStatus: ComplaintStatus.OPEN,
      raisedAt: DateTime.now().subtract(const Duration(hours: 4)),
    ),
    RaiseComplainResponse(
      complaintId: 102,
      flatId: 0, // Common Building Grounds
      residentId: 99,
      complaintCategoryId: 2,
      title: 'Balcony Light Switch Faulty',
      description: 'The automated spark fuses frequently when turned on.',
      priority: Priority.MEDIUM,
      complaintStatus: ComplaintStatus.IN_PROGRESS,
      raisedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    RaiseComplainResponse(
      complaintId: 103,
      flatId: -1, // Entire Society Grounds
      residentId: 102,
      complaintCategoryId: 5,
      title: 'Main Gate Boom Barrier Malfunction',
      description: 'RFID scanner failing to authentic entry tokens during peak hours.',
      priority: Priority.HIGH,
      complaintStatus: ComplaintStatus.OPEN,
      raisedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Color _getStatusColor(ComplaintStatus status) {
    switch (status) {
      case ComplaintStatus.OPEN: return Colors.blue;
      case ComplaintStatus.ASSIGNED: return Colors.indigo;
      case ComplaintStatus.IN_PROGRESS: return Colors.orange;
      case ComplaintStatus.RESOLVED: return Colors.green;
      case ComplaintStatus.CLOSED: return Colors.grey;
      case ComplaintStatus.REOPENED: return Colors.purple;
      case ComplaintStatus.CANCELLED: return Colors.red;
    }
  }

  bool _hasActiveFilters() {
    return _filterCategoryId != null || _filterStatus != null || _filterFilterSubmittedByString() != null;
  }

  String? _filterFilterSubmittedByString() => _filterSubmittedBy;

  void _clearAllFilters() {
    setState(() {
      _filterCategoryId = null;
      _filterStatus = null;
      _filterSubmittedBy = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F7),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0D2C54),
        title: const Text('Society Helpdesk', style: TextStyle(color: Colors.white, fontSize: 18)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          indicatorColor: Colors.tealAccent,
          labelStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          tabs: const [
            Tab(text: 'Active Logs'),
            Tab(text: 'Resolved'),
            Tab(text: 'All Claims'),
          ],
        ),
      ),
      body: Column(
        children: [
          _buildFilterChipBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildComplaintList(tabFilter: 'ACTIVE'),
                _buildComplaintList(tabFilter: 'RESOLVED'),
                _buildComplaintList(tabFilter: 'ALL'),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF0D2C54),
        onPressed: () => context.push(AppRouter.raiseComplain),
        icon: const Icon(Icons.add_comment_outlined, color: Colors.white),
        label: const Text('Raise Complain', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  // --- Horizontal Filter Triggers UI Row ---
  Widget _buildFilterChipBar() {
    final categoryName = _filterCategoryId == null
        ? 'Category'
        : _categories.firstWhere((c) => c['id'] == _filterCategoryId)['name'];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            if (_hasActiveFilters()) ...[
              IconButton(
                icon: const Icon(Icons.filter_alt_off, color: Colors.redAccent, size: 20),
                onPressed: _clearAllFilters,
                tooltip: 'Clear Filters',
              ),
              const VerticalDivider(width: 8),
            ],
            // 1. Category Picker Chip
            FilterChip(
              label: Text(categoryName),
              selected: _filterCategoryId != null,
              onSelected: (_) => _showCategoryFilterSheet(),
            ),
            const SizedBox(width: 8),
            // 2. Pure Status Enum Filter Chip
            FilterChip(
              label: Text(_filterStatus == null ? 'Status' : _filterStatus!.name),
              selected: _filterStatus != null,
              onSelected: (_) => _showStatusFilterSheet(),
            ),
            const SizedBox(width: 8),
            // 3. Submitted By Area Allocation Filter Chip
            FilterChip(
              label: Text(_filterSubmittedBy == null ? 'Submitted By' : _filterSubmittedBy!),
              selected: _filterSubmittedBy != null,
              onSelected: (_) => _showSubmittedByFilterSheet(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComplaintList({required String tabFilter}) {
    final filtered = _mockBackendComplaints.where((c) {
      // 1. Evaluate Underlying Tab Lifecycles
      if (tabFilter == 'ACTIVE') {
        if (c.complaintStatus == ComplaintStatus.RESOLVED || c.complaintStatus == ComplaintStatus.CLOSED || c.complaintStatus == ComplaintStatus.CANCELLED) {
          return false;
        }
      } else if (tabFilter == 'RESOLVED') {
        if (c.complaintStatus != ComplaintStatus.RESOLVED) return false;
      }

      // 2. Evaluate Category Filters
      if (_filterCategoryId != null && c.complaintCategoryId != _filterCategoryId) {
        return false;
      }

      // 3. Evaluate Status Filters
      if (_filterStatus != null && c.complaintStatus != _filterStatus) {
        return false;
      }

      // 4. Evaluate Submitted By Target Scope
      if (_filterSubmittedBy != null) {
        if (_filterSubmittedBy == 'My Flat' && c.flatId != 402) return false;
        if (_filterSubmittedBy == 'Building' && c.flatId != 0) return false;
        if (_filterSubmittedBy == 'Society' && c.flatId != -1) return false;
      }

      return true;
    }).toList();

    if (filtered.isEmpty) {
      return const Center(
        child: Text('No complaints match your active filter configurations.'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final item = filtered[index];
        final catName = _categories.firstWhere(
                (c) => c['id'] == item.complaintCategoryId,
            orElse: () => {'name': 'General'}
        )['name'];

        return Card(
          color: Colors.white,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 1.5,
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => context.push('/complaints/detail', extra: item),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getStatusColor(item.complaintStatus).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          item.complaintStatus.name,
                          style: TextStyle(color: _getStatusColor(item.complaintStatus), fontWeight: FontWeight.bold, fontSize: 11),
                        ),
                      ),
                      Text(
                        'PRIORITY ${item.priority.name}',
                        style: TextStyle(
                          color: item.priority == Priority.HIGH ? Colors.red : Colors.grey,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF0D2C54))),
                  const SizedBox(height: 4),
                  Text('Category: $catName', style: const TextStyle(fontSize: 12, color: Colors.blueGrey, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 6),
                  Text(item.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Ticket ID: #${item.complaintId}', style: const TextStyle(fontSize: 12, color: Colors.blueGrey)),
                      const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // --- Filter Selector Bottom Sheets ---

  void _showCategoryFilterSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Filter by Category', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView(
                  children: [
                    ListTile(
                      title: const Text('All Categories'),
                      trailing: _filterCategoryId == null ? const Icon(Icons.check, color: Colors.blue) : null,
                      onTap: () {
                        setState(() => _filterCategoryId = null);
                        Navigator.pop(context);
                      },
                    ),
                    ..._categories.map((cat) => ListTile(
                      title: Text(cat['name']),
                      trailing: _filterCategoryId == cat['id'] ? const Icon(Icons.check, color: Colors.blue) : null,
                      onTap: () {
                        setState(() => _filterCategoryId = cat['id'] as int);
                        Navigator.pop(context);
                      },
                    )),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showStatusFilterSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Filter by Complaint Status', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView(
                  children: [
                    ListTile(
                      title: const Text('All Statuses'),
                      trailing: _filterStatus == null ? const Icon(Icons.check, color: Colors.blue) : null,
                      onTap: () {
                        setState(() => _filterStatus = null);
                        Navigator.pop(context);
                      },
                    ),
                    ...ComplaintStatus.values.map((status) => ListTile(
                      title: Text(status.name),
                      trailing: _filterStatus == status ? const Icon(Icons.check, color: Colors.blue) : null,
                      onTap: () {
                        setState(() => _filterStatus = status);
                        Navigator.pop(context);
                      },
                    )),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  void _showSubmittedByFilterSheet() {
    final options = ['My Flat', 'Building', 'Society'];
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Filter by Scope / Submitted By', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              const Divider(height: 1),
              ...options.map((opt) => ListTile(
                title: Text(opt),
                trailing: _filterSubmittedBy == opt ? const Icon(Icons.check, color: Colors.blue) : null,
                onTap: () {
                  setState(() => _filterSubmittedBy = opt);
                  Navigator.pop(context);
                },
              )),
              ListTile(
                title: const Text('Clear Scope Filter'),
                onTap: () {
                  setState(() => _filterSubmittedBy = null);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}