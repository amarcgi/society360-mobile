import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/AppColors.dart';
import 'bloc/accounting_bloc.dart';
import 'bloc/accounting_event.dart';
import 'model/invoice_Item.dart';
import 'package:go_router/go_router.dart';

class DuesScreen extends StatefulWidget {
  const DuesScreen({super.key});

  @override
  State<DuesScreen> createState() => _DuesScreenState();
}

class _DuesScreenState extends State<DuesScreen> {
  // Track selected invoice indices
  Set<int> _selectedIndices = {};
  bool _isInitialized = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountingBloc, AccountingState>(builder: (context, state) {
      // Automatically select all items on initial load
      if (!_isInitialized && state.invoices.isNotEmpty) {
        _selectedIndices = Set.from(List.generate(state.invoices.length, (index) => index));
        _isInitialized = true;
      }

      final bool isAllSelected = state.invoices.isNotEmpty && _selectedIndices.length == state.invoices.length;

      // Calculate total amount based ONLY on selected items
      double totalSelectedAmount = 0.0;
      for (int i = 0; i < state.invoices.length; i++) {
        if (_selectedIndices.contains(i)) {
          totalSelectedAmount += state.invoices[i].amount;
        }
      }

      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Total Due Summary Card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF0F2D52),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                const Text(
                  "SELECTED TOTAL DUE",
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  "₹$totalSelectedAmount",
                  style: const TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _selectedIndices.isEmpty
                      ? null
                      : () {
                    // TODO: Trigger payment gateway for selected invoices
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00C2CB),
                    disabledBackgroundColor: Colors.grey,
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: Text(
                    _selectedIndices.isEmpty
                        ? "SELECT ITEMS TO PAY"
                        : "PAY SELECTED (${_selectedIndices.length}) - ₹$totalSelectedAmount",
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
          //const SizedBox(height: 16),

          // Select All / Deselect All Header Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Invoices (${_selectedIndices.length}/${state.invoices.length} selected)",
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
                ),
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      if (isAllSelected) {
                        _selectedIndices.clear(); // Deselect all
                      } else {
                        _selectedIndices = Set.from(List.generate(state.invoices.length, (index) => index)); // Select all
                      }
                    });
                  },
                  icon: Icon(
                    isAllSelected ? Icons.deselect : Icons.select_all,
                    size: 18,
                  ),
                  label: Text(isAllSelected ? "Deselect All" : "Select All"),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF0F2D52),
                  ),
                ),
              ],
            ),
          ),
          //const SizedBox(height: 8),

          // Invoice List with Checkboxes
          ...state.invoices.asMap().entries.map((entry) {
            final index = entry.key;
            final inv = entry.value;
            final isSelected = _selectedIndices.contains(index);

            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                title: Text(
                  inv.title,
                  style: const TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    "Due: ${inv.dueDate.day}/${inv.dueDate.month}/${inv.dueDate.year}",
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Amount & Status Badge
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "₹${inv.amount}",
                          style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: inv.status.toLowerCase() == 'paid' ? Colors.green : Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            inv.status,
                            style: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    // Checkbox for selection
                    Checkbox(
                      value: isSelected,
                      activeColor: const Color(0xFF0F2D52),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            _selectedIndices.add(index);
                          } else {
                            _selectedIndices.remove(index);
                          }
                        });
                      },
                    ),
                  ],
                ),
                onTap: () => _showInvoiceDetails(context, inv),
              ),
            );
          }),
        ],
      );
    });
  }

  void _showInvoiceDetails(BuildContext context, InvoiceItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: SingleChildScrollView(
          child: SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(item.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const Divider(),
                  const ListTile(title: Text("Invoice #"), trailing: Text("INV356", style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w500))),
                  ListTile(title: Text("Due date"), trailing: Text("${item.dueDate.day}/${item.dueDate.month}/${item.dueDate.year}", style: const TextStyle(color: Colors.black, fontSize: 15))),
                  const ListTile(title: Text("Flat"), trailing: Text("310", style: TextStyle(color: Colors.black, fontSize: 15))),
                  const ListTile(title: Text("Building"), trailing: Text("B-Block", style: TextStyle(color: Colors.black, fontSize: 15))),
                  const ListTile(title: Text("Fine"), trailing: Text("₹100", style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold))),
                  ListTile(title: Text("Amount"), trailing: Text("₹${item.amount}", style: const TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold))),
                  const ListTile(title: Text("Net Payable Amount"), trailing: Text("₹4000", style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold))),
                  if ((item.description ?? '').isNotEmpty) ...[
                    const SizedBox(height: 8),
                    const Align(alignment: Alignment.centerLeft, child: Text("Description", style: TextStyle(fontWeight: FontWeight.bold))),
                    const SizedBox(height: 4),
                    Text(item.description ?? 'No description available'),
                  ],
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text("PAY NOW"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}