
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'model/society_expense_Item.dart';
class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});
  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  String _filter = "Monthly";
  DateTimeRange? _selectedRange;

  // Mock Data
  final List<SocietyExpenseItem> _allExpenses = [
    SocietyExpenseItem(id: '1', title: 'Security Guard Salary', amount: 35000, date: DateTime.now(), type: 'Debit', description: 'Monthly salary for guards', txnNo: 'TXN-001'),
    SocietyExpenseItem(id: '2', title: 'Maintenance Collection', amount: 150000, date: DateTime.now(), type: 'Credit', description: 'Maintenance received', txnNo: 'TXN-002'),
    SocietyExpenseItem(id: '1', title: 'Security Guard Salary', amount: 35000, date: DateTime.now(), type: 'Debit', description: 'Monthly salary for guards', txnNo: 'TXN-001'),
    SocietyExpenseItem(id: '2', title: 'Maintenance Collection', amount: 150000, date: DateTime.now(), type: 'Credit', description: 'Maintenance received', txnNo: 'TXN-002'),
    SocietyExpenseItem(id: '1', title: 'Security Guard Salary', amount: 35000, date: DateTime.now(), type: 'Debit', description: 'Monthly salary for guards', txnNo: 'TXN-001'),
    SocietyExpenseItem(id: '2', title: 'Maintenance Collection', amount: 150000, date: DateTime.now(), type: 'Credit', description: 'Maintenance received', txnNo: 'TXN-002'),
    SocietyExpenseItem(id: '1', title: 'Security Guard Salary', amount: 35000, date: DateTime.now(), type: 'Debit', description: 'Monthly salary for guards', txnNo: 'TXN-001'),
    SocietyExpenseItem(id: '2', title: 'Maintenance Collection', amount: 150000, date: DateTime.now(), type: 'Credit', description: 'Maintenance received', txnNo: 'TXN-002'),
    SocietyExpenseItem(id: '1', title: 'Security Guard Salary', amount: 35000, date: DateTime.now(), type: 'Debit', description: 'Monthly salary for guards', txnNo: 'TXN-001'),
    SocietyExpenseItem(id: '2', title: 'Maintenance Collection', amount: 150000, date: DateTime.now(), type: 'Credit', description: 'Maintenance received', txnNo: 'TXN-002'),
    SocietyExpenseItem(id: '1', title: 'Security Guard Salary', amount: 35000, date: DateTime.now(), type: 'Debit', description: 'Monthly salary for guards', txnNo: 'TXN-001'),
    SocietyExpenseItem(id: '2', title: 'Maintenance Collection', amount: 150000, date: DateTime.now(), type: 'Credit', description: 'Maintenance received', txnNo: 'TXN-002'),
    SocietyExpenseItem(id: '1', title: 'Security Guard Salary', amount: 35000, date: DateTime.now(), type: 'Debit', description: 'Monthly salary for guards', txnNo: 'TXN-001'),
    SocietyExpenseItem(id: '2', title: 'Maintenance Collection', amount: 150000, date: DateTime.now(), type: 'Credit', description: 'Maintenance received', txnNo: 'TXN-002'),
    SocietyExpenseItem(id: '1', title: 'Security Guard Salary', amount: 35000, date: DateTime.now(), type: 'Debit', description: 'Monthly salary for guards', txnNo: 'TXN-001'),
    SocietyExpenseItem(id: '2', title: 'Maintenance Collection', amount: 150000, date: DateTime.now(), type: 'Credit', description: 'Maintenance received', txnNo: 'TXN-002'),
    SocietyExpenseItem(id: '1', title: 'Security Guard Salary', amount: 35000, date: DateTime.now(), type: 'Debit', description: 'Monthly salary for guards', txnNo: 'TXN-001'),
    SocietyExpenseItem(id: '2', title: 'Maintenance Collection', amount: 150000, date: DateTime.now(), type: 'Credit', description: 'Maintenance received', txnNo: 'TXN-002'),
    SocietyExpenseItem(id: '1', title: 'Security Guard Salary', amount: 35000, date: DateTime.now(), type: 'Debit', description: 'Monthly salary for guards', txnNo: 'TXN-001'),
    SocietyExpenseItem(id: '2', title: 'Maintenance Collection', amount: 150000, date: DateTime.now(), type: 'Credit', description: 'Maintenance received', txnNo: 'TXN-002'),
    SocietyExpenseItem(id: '1', title: 'Security Guard Salary', amount: 35000, date: DateTime.now(), type: 'Debit', description: 'Monthly salary for guards', txnNo: 'TXN-001'),
    SocietyExpenseItem(id: '2', title: 'Maintenance Collection', amount: 150000, date: DateTime.now(), type: 'Credit', description: 'Maintenance received', txnNo: 'TXN-002'),
    SocietyExpenseItem(id: '1', title: 'Security Guard Salary', amount: 35000, date: DateTime.now(), type: 'Debit', description: 'Monthly salary for guards', txnNo: 'TXN-001'),
    SocietyExpenseItem(id: '2', title: 'Maintenance Collection', amount: 150000, date: DateTime.now(), type: 'Credit', description: 'Maintenance received', txnNo: 'TXN-002'),
    SocietyExpenseItem(id: '1', title: 'Security Guard Salary', amount: 35000, date: DateTime.now(), type: 'Debit', description: 'Monthly salary for guards', txnNo: 'TXN-001'),
    SocietyExpenseItem(id: '2', title: 'Maintenance Collection', amount: 150000, date: DateTime.now(), type: 'Credit', description: 'Maintenance received', txnNo: 'TXN-002'),
    SocietyExpenseItem(id: '1', title: 'Security Guard Salary', amount: 35000, date: DateTime.now(), type: 'Debit', description: 'Monthly salary for guards', txnNo: 'TXN-001'),
    SocietyExpenseItem(id: '2', title: 'Maintenance Collection', amount: 150000, date: DateTime.now(), type: 'Credit', description: 'Maintenance received', txnNo: 'TXN-002'),
    SocietyExpenseItem(id: '1', title: 'Security Guard Salary', amount: 35000, date: DateTime.now(), type: 'Debit', description: 'Monthly salary for guards', txnNo: 'TXN-001'),
    SocietyExpenseItem(id: '2', title: 'Maintenance Collection', amount: 150000, date: DateTime.now(), type: 'Credit', description: 'Maintenance received', txnNo: 'TXN-002'),
    SocietyExpenseItem(id: '1', title: 'Security Guard Salary', amount: 35000, date: DateTime.now(), type: 'Debit', description: 'Monthly salary for guards', txnNo: 'TXN-001'),
    SocietyExpenseItem(id: '2', title: 'Maintenance Collection', amount: 150000, date: DateTime.now(), type: 'Credit', description: 'Maintenance received', txnNo: 'TXN-002'),
    SocietyExpenseItem(id: '1', title: 'Security Guard Salary', amount: 35000, date: DateTime.now(), type: 'Debit', description: 'Monthly salary for guards', txnNo: 'TXN-001'),
    SocietyExpenseItem(id: '2', title: 'Maintenance Collection', amount: 150000, date: DateTime.now(), type: 'Credit', description: 'Maintenance received', txnNo: 'TXN-002'),
    SocietyExpenseItem(id: '1', title: 'Security Guard Salary', amount: 35000, date: DateTime.now(), type: 'Debit', description: 'Monthly salary for guards', txnNo: 'TXN-001'),
    SocietyExpenseItem(id: '2', title: 'Maintenance Collection', amount: 150000, date: DateTime.now(), type: 'Credit', description: 'Maintenance received', txnNo: 'TXN-002'),
    SocietyExpenseItem(id: '1', title: 'Security Guard Salary', amount: 35000, date: DateTime.now(), type: 'Debit', description: 'Monthly salary for guards', txnNo: 'TXN-001'),
    SocietyExpenseItem(id: '2', title: 'Maintenance Collection', amount: 150000, date: DateTime.now(), type: 'Credit', description: 'Maintenance received', txnNo: 'TXN-002'),
    SocietyExpenseItem(id: '1', title: 'Security Guard Salary', amount: 35000, date: DateTime.now(), type: 'Debit', description: 'Monthly salary for guards', txnNo: 'TXN-001'),
    SocietyExpenseItem(id: '2', title: 'Maintenance Collection', amount: 150000, date: DateTime.now(), type: 'Credit', description: 'Maintenance received', txnNo: 'TXN-002'),
    SocietyExpenseItem(id: '1', title: 'Security Guard Salary', amount: 35000, date: DateTime.now(), type: 'Debit', description: 'Monthly salary for guards', txnNo: 'TXN-001'),
    SocietyExpenseItem(id: '2', title: 'Maintenance Collection', amount: 150000, date: DateTime.now(), type: 'Credit', description: 'Maintenance received', txnNo: 'TXN-002'),
  ];

  // Filtering Logic
  List<SocietyExpenseItem> get _filteredExpenses {
    final now = DateTime.now();
    if (_filter == "Weekly") {
      return _allExpenses.where((e) => e.date.isAfter(now.subtract(const Duration(days: 7)))).toList();
    } else if (_filter == "Monthly") {
      return _allExpenses.where((e) => e.date.month == now.month && e.date.year == now.year).toList();
    } else if (_filter == "Range" && _selectedRange != null) {
      return _allExpenses.where((e) =>
      e.date.isAfter(_selectedRange!.start.subtract(const Duration(days: 1))) &&
          e.date.isBefore(_selectedRange!.end.add(const Duration(days: 1)))
      ).toList();
    }
    return _allExpenses;
  }

  Future<void> _pickRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2025),
      lastDate: DateTime(2027),
    );
    if (picked != null) {
      setState(() {
        _selectedRange = picked;
        _filter = "Range";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Wrap(
            spacing: 8,
            children: ["Weekly", "Monthly", "Range"].map((f) => ChoiceChip(
              label: Text(f), selected: _filter == f,
              onSelected: (s) {
                if (f == "Range") _pickRange();
                else setState(() => _filter = f);
              },
            )).toList(),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _filteredExpenses.length,
            itemBuilder: (context, i) {
              final item = _filteredExpenses[i];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(item.txnNo, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      Text(item.date.toString().split(' ')[0], style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      Text(item.type, style: TextStyle(fontSize: 12, color: item.type == 'Debit' ? Colors.red : Colors.green)),
                    ],
                  ),
                  trailing: Text(
                    "${item.type == 'Debit' ? '-' : '+'} ₹${item.amount}",
                    style: TextStyle(
                        color: item.type == 'Debit' ? Colors.red : Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                    ),
                  ),
                  onTap: () => _showDetails(item),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showDetails(SocietyExpenseItem item) {
    // Reusing the same BottomSheet logic from before
    showModalBottomSheet(context: context, builder: (ctx) => Padding(
      padding: const EdgeInsets.all(20),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(item.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const Divider(),
        _row("Transaction No", item.txnNo),
        _row("Date", item.date.toString().split(' ')[0]),
        _row("Type", item.type),
        _row("Amount", "₹ ${item.amount}"),
        const SizedBox(height: 10),
        const Text("Description:", style: TextStyle(fontWeight: FontWeight.bold)),
        Text(item.description),
      ]),
    ));
  }

  Widget _row(String l, String v) => Padding(padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(l), Text(v, style: const TextStyle(fontWeight: FontWeight.bold))]));
}