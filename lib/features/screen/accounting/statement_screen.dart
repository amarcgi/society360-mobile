import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'model/transaction_Item.dart';
class StatementScreen extends StatefulWidget {
  const StatementScreen({super.key});
  @override
  State<StatementScreen> createState() => _StatementScreenState();
}

class _StatementScreenState extends State<StatementScreen> {
  String _selectedFilter = "ALL";
  DateTimeRange? _customDateRange;
  final List<TransactionItem> _allTransactions = [
    // Current Month (June 2026)
    TransactionItem(title: "Maintenance Fee", amount: 2500.0, date: DateTime(2026, 6, 2), type: "Debit"),

    // Previous Month (May 2026)
    TransactionItem(title: "Water Charges", amount: 1700.0, date: DateTime(2026, 5, 15), type: "Debit"),
    TransactionItem(title: "Building Repair Fund", amount: 500.0, date: DateTime(2026, 5, 20), type: "Debit"),
    TransactionItem(title: "Parking Refund", amount: 300.0, date: DateTime(2026, 5, 22), type: "Credit"),

    // Last Year (2025)
    TransactionItem(title: "Annual Society Dues", amount: 5000.0, date: DateTime(2025, 12, 1), type: "Debit"),
    TransactionItem(title: "Festival Contribution", amount: 1000.0, date: DateTime(2025, 10, 10), type: "Debit"),
    TransactionItem(title: "Late Payment Penalty", amount: 200.0, date: DateTime(2025, 9, 5), type: "Debit"),
  ];
  // Logic to filter based on selection
  List<TransactionItem> get _filteredTransactions {
    final now = DateTime.now();
    if (_selectedFilter == "MONTH") {
      return _allTransactions.where((t) => t.date.month == now.month && t.date.year == now.year).toList();
    } else if (_selectedFilter == "YEAR") {
      return _allTransactions.where((t) => t.date.year == now.year).toList();
    } else if (_selectedFilter == "CUSTOM" && _customDateRange != null) {
      return _allTransactions.where((t) =>
      t.date.isAfter(_customDateRange!.start.subtract(const Duration(days: 1))) &&
          t.date.isBefore(_customDateRange!.end.add(const Duration(days: 1)))
      ).toList();
    }
    return _allTransactions;
  }

  Future<void> _pickDateRange() async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2025),
      lastDate: DateTime(2027),
    );
    if (picked != null) {
      setState(() {
        _customDateRange = picked;
        _selectedFilter = "CUSTOM";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Wrap(
            spacing: 8,
            children: ["ALL", "MONTH", "YEAR", "CUSTOM"].map((filter) => ChoiceChip(
              label: Text(filter),
              selected: _selectedFilter == filter,
              onSelected: (selected) {
                if (filter == "CUSTOM") {
                  _pickDateRange();
                } else {
                  setState(() => _selectedFilter = filter);
                }
              },
            )).toList(),
          ),
        ),
        // Display selected range info
        if (_selectedFilter == "CUSTOM" && _customDateRange != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text("Showing: ${_customDateRange!.start.day}/${_customDateRange!.start.month} - ${_customDateRange!.end.day}/${_customDateRange!.end.month}"),
          ),
        Expanded(
          child: ListView.builder(
            itemCount: _filteredTransactions.length,
            itemBuilder: (context, index) {
              final item = _filteredTransactions[index];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.title, style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text("${item.date.day}/${item.date.month}/${item.date.year}", style: TextStyle(color: Colors.grey[700])),
                            const SizedBox(height: 2),
                            Text("Inv: INV-${item.date.year}${item.date.month.toString().padLeft(2, '0')}${item.date.day.toString().padLeft(2, '0')}-${index + 1}", style: TextStyle(color: Colors.grey[700])),
                            const SizedBox(height: 2),
                            Text("Status: ${item.type}", style: TextStyle(color: item.type == 'Debit' ? Colors.red : Colors.green)),
                          ],
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "${item.type == 'Debit' ? '-' : '+'} ₹${item.amount}",
                            style: TextStyle(color: item.type == 'Debit' ? Colors.red : Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}