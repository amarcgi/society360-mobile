import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:society360_app/core/router/app_router.dart';

import 'model/visitor_history_model.dart';
class VisitorDetailScreen extends StatelessWidget {
  final VisitorHistoryModel visitor;
  const VisitorDetailScreen({super.key,required this.visitor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D2C54),
        title: const Text('Visitor Detail', style: TextStyle(color: Colors.white, fontSize: 18)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go(AppRouter.visitorHistory),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            const CircleAvatar(radius: 36, backgroundColor: Color(0xFFE5E9F0), child: Text('RK', style: TextStyle(fontSize: 24))),
            const SizedBox(height: 12),
            const Text('Rajesh Kumar', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const Text('Plumber / Service', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            Chip(label: const Text('Expected Today', style: TextStyle(color: Colors.teal)), backgroundColor: Colors.teal.shade50, side: BorderSide.none),
            const SizedBox(height: 24),
            _buildDetailRow('Mobile', '+91 9876543210'),
            _buildDetailRow('Visiting', 'Tower A - Flat 402'),
            _buildDetailRow('Date', 'Today, 30 May 2026'),
            _buildDetailRow('Duration', '2-3 Hour expected'),
            const SizedBox(height: 24),
            const Align(alignment: Alignment.centerLeft, child: Text('VISIT ACTIVITY', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey))),
            const SizedBox(height: 16),
            _buildTimelineStep('Pre-approved by resident', '09:15 AM • From App', isFirst: true, isDone: true),
            _buildTimelineStep('Checked at Main Gate', '10:30 AM • Guard verified', isDone: true),
            _buildTimelineStep('Check out pending', 'Waiting entry exit', isLast: true),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(child: OutlinedButton(onPressed: () {}, child: const Text('Edit Entry'))),
                const SizedBox(width: 12),
                Expanded(child: OutlinedButton(onPressed: () {}, child: const Text('Resend Notification'))),
              ],
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red, minimumSize: const Size(double.infinity, 48)),
              onPressed: () => context.go('/visitor-management/gate-approval'),
              child: const Text('Mark as Unapproved Lock', style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildTimelineStep(String label, String sub, {bool isFirst = false, bool isLast = false, bool isDone = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Icon(isDone ? Icons.check_circle : Icons.radio_button_unchecked, color: isDone ? Colors.teal : Colors.grey, size: 20),
            if (!isLast) Container(width: 2, height: 40, color: Colors.grey.shade300),
          ],
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: isDone ? Colors.black : Colors.grey)),
            Text(sub, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        )
      ],
    );
  }
}