import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:society360_app/core/router/app_router.dart';
class AddVisitorScreen extends StatefulWidget {
  const AddVisitorScreen({super.key});

  @override
  State<AddVisitorScreen> createState() => _AddVisitorScreenState();
}

class _AddVisitorScreenState extends State<AddVisitorScreen> {
  String selectedType = 'Guest';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D2C54),
        title: const Text('Add Visitor', style: TextStyle(color: Colors.white, fontSize: 18)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () =>{context.go(AppRouter.dashboard)}
        ),
        actions: [
          IconButton(icon: const Icon(Icons.library_books_sharp, color: Colors.white), onPressed: () {
            context.push(AppRouter.visitorHistory);
          }),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8)),
              child: const Text(
                'Security guards will be notified and verify the individual at the gate once saved.',
                style: TextStyle(color: Colors.blue, fontSize: 13),
              ),
            ),
            const SizedBox(height: 20),
            _buildInputField('VISITOR NAME *', 'Enter full name'),
            const SizedBox(height: 16),
            _buildInputField('MOBILE NUMBER *', 'Enter phone number'),
            const SizedBox(height: 16),
            const Text('VISITOR TYPE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 8),
            _buildVisitorTypeWrap(),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildInputField('EXPECTED DATE', 'Today')),
                const SizedBox(width: 12),
                Expanded(child: _buildInputField('EXPECTED TIME', 'Select time')),
              ],
            ),
            const SizedBox(height: 16),
            _buildInputField('PURPOSE (OPTIONAL)', 'Add brief note details'),
            const SizedBox(height: 32),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                side: const BorderSide(color: Color(0xFF0D2C54)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {},
              child: const Text('Pre-approve Visitor', style: TextStyle(color: Color(0xFF0D2C54))),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D2C54),
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => context.go('/visitor-management/visitor-detail'),
              child: const Text('Save Notification', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
        const SizedBox(height: 6),
        TextField(
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }

  Widget _buildVisitorTypeWrap() {
    final types = ['Guest', 'Delivery', 'Services', 'Cab Driver', 'Other'];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: types.map((type) {
        final isSelected = selectedType == type;
        return ChoiceChip(
          label: Text(type),
          selected: isSelected,
          selectedColor: const Color(0xFF0D2C54),
          selectedShadowColor: isSelected ? Colors.white : Colors.black,
          backgroundColor: Colors.white,
          onSelected: (_) => setState(() => selectedType = type),
        );
      }).toList(),
    );
  }
}