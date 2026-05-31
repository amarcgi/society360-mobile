import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
class GateApprovalScreen extends StatelessWidget {
  const GateApprovalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D2C54),
        title: const Text('Gate Approval', style: TextStyle(color: Colors.white, fontSize: 18)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go('/visitor-management/visitor-detail'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildApprovalCard('Ramesh Delivery', 'Amazon Delivery Partner • Waiting at Main Gate'),
            const SizedBox(height: 12),
            _buildActionRequiredCard('Unknown Entry', 'Car No: MH12-AB-1234 • Gate Entrance'),
            const SizedBox(height: 24),
            const Text('RECENT ACTIONS PROGRESSION', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 12),
            _buildActionHistoryRow('Rajesh Kumar', 'Allowed • 10:30 AM', Colors.green),
            _buildActionHistoryRow('Unknown Visitor', 'Denied Entry • 09:12 AM', Colors.red),
            _buildActionHistoryRow('Utility Worker', 'Allowed via Call • Yesterday', Colors.blue),
          ],
        ),
      ),
    );
  }

  Widget _buildApprovalCard(String title, String body) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(backgroundColor: Color(0xFFE5E9F0), child: Icon(Icons.local_shipping)),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.bold)), Text(body, style: const TextStyle(fontSize: 12, color: Colors.grey))])),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.green), onPressed: () {}, child: const Text('Allow', style: TextStyle(color: Colors.white))),
              ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.red), onPressed: () {}, child: const Text('Deny', style: TextStyle(color: Colors.white))),
              OutlinedButton(onPressed: () {}, child: const Text('Call')),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildActionRequiredCard(String title, String body) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.orangeAccent)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.bold)), Text(body, style: const TextStyle(fontSize: 12, color: Colors.grey))]),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0D2C54)),
            onPressed: () {},
            child: const Text('Action', style: TextStyle(color: Colors.white, fontSize: 12)),
          )
        ],
      ),
    );
  }

  Widget _buildActionHistoryRow(String title, String status, Color color) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const CircleAvatar(backgroundColor: Color(0xFFE5E9F0), child: Icon(Icons.history)),
      title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      subtitle: Text(status, style: TextStyle(fontSize: 12, color: color)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
    );
  }
}