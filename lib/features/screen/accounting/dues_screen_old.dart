// --- TAB SCREENS (All Stateful) ---

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
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountingBloc, AccountingState>(builder: (context, state) {
      return ListView(padding: const EdgeInsets.all(16), children: [
        // Total Due Card
        Container(padding: const EdgeInsets.all(24), decoration: BoxDecoration(color: const Color(0xFF0F2D52), borderRadius: BorderRadius.circular(20)),
          child: Column(children: [
            const Text("TOTAL DUE", style: TextStyle(color: Colors.white,fontSize: 18, fontWeight: FontWeight.bold)),
            Text("₹${state.invoices.fold(0.0, (s, i) => s + i.amount)}", style: const TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold)),
            ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00C2CB), minimumSize: const Size(double.infinity, 48)), child: const Text("PAY ALL NOW")),
          ]),
        ),
        const SizedBox(height: 20),
        ...state.invoices.map((inv) => Card(child: ListTile(
          title: Text(inv.title,style: TextStyle(color: Colors.black,fontSize: 18, fontWeight: FontWeight.bold)),
          subtitle: Text("Due: ${inv.dueDate.day}/${inv.dueDate.month}",style: TextStyle(color: Colors.black,fontSize: 15)),
          trailing: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text("₹${inv.amount}",style: TextStyle(color: Colors.black,fontSize: 18, fontWeight: FontWeight.bold)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(inv.status, style: const TextStyle(fontSize: 12, color: Colors.white)),
            ),
          ]),
          onTap: () => _showInvoiceDetails(context, inv),
        ))),
      ]);
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
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Text(item.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const Divider(),
                ListTile(title: const Text("Invoice #"), trailing: const Text("INV356", style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w500))),
                ListTile(title: const Text("Due date"), trailing: Text("${item.dueDate.day}/${item.dueDate.month}", style: const TextStyle(color: Colors.black, fontSize: 15))),
                ListTile(title: const Text("Flat"), trailing: const Text("310", style: TextStyle(color: Colors.black, fontSize: 15))),
                ListTile(title: const Text("Building"), trailing: const Text("B-Block", style: TextStyle(color: Colors.black, fontSize: 15))),
                ListTile(title: const Text("Fine"), trailing: const Text("₹100", style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold))),
                ListTile(title: const Text("Amount"), trailing: Text("₹${item.amount}", style: const TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold))),
                ListTile(title: const Text("Nat Payble Amount"), trailing: const Text("₹4000", style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold))),
                if ((item.description ?? '').isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Align(alignment: Alignment.centerLeft, child: const Text("Description", style: TextStyle(fontWeight: FontWeight.bold))),
                  const SizedBox(height: 4),
                  Text(item.description ?? 'No description available'),
                ],
                const SizedBox(height: 12),
                SizedBox(width: double.infinity, height: 48, child: ElevatedButton(onPressed: () {}, child: const Text("PAY NOW")))
              ]),
            ),
          ),
        ),
      ),
    );
  }
}