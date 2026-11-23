import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:society360_app/features/screen/accounting/payment_checkout_screen.dart';

import '../../../core/theme/AppColors.dart';
import 'bloc/accounting_bloc.dart';
import 'bloc/accounting_event.dart';
import 'bloc/accounting_state.dart';
import 'model/invoice_Item.dart';
import 'package:go_router/go_router.dart';

import 'model/payment_checkout_args.dart';

class DuesScreen extends StatefulWidget {
  final AccountingBloc accountingBloc;

  const DuesScreen({
    super.key,
    required this.accountingBloc,
  });

  @override
  State<DuesScreen> createState() => _DuesScreenState();
}

class _DuesScreenState extends State<DuesScreen> {
  // Track selected invoice indices
  Set<int> _selectedIndices = {};
  bool _isInitialized = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountingBloc, AccountingState>(
      bloc: widget.accountingBloc,
      builder: (context, state) {
        print('state.invoices.length: ${state.invoices.length}');

        // Automatically select all items on initial load
        if (!_isInitialized && state.invoices.isNotEmpty) {
          _selectedIndices = Set.from(List.generate(state.invoices.length, (index) => index));
          _isInitialized = true;
        }

        final bool isAllSelected =
            state.invoices.isNotEmpty && _selectedIndices.length == state.invoices.length;

        // Calculate total amount based ONLY on selected items
        double totalSelectedAmount = 0.0;
        final List<InvoiceItem> selectedInvoices = [];
        for (int i = 0; i < state.invoices.length; i++) {
          if (_selectedIndices.contains(i)) {
            totalSelectedAmount += state.invoices[i].totalAmount;
            selectedInvoices.add(state.invoices[i]);
          }
        }

        return ListView(
          padding: const EdgeInsets.all(10),
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
                    "₹${totalSelectedAmount.toStringAsFixed(2)}",
                    style: const TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _selectedIndices.isEmpty
                        ? null
                        : () {
                      // TODO: Trigger full payment for selected invoices
                      _onProceedPayment(
                        amount: totalSelectedAmount,
                        isPartial: false,
                        invoices: selectedInvoices,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00C2CB),
                      disabledBackgroundColor: Colors.grey,
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: Text(
                      _selectedIndices.isEmpty
                          ? "SELECT ITEMS TO PAY"
                          : "PAY SELECTED (${_selectedIndices.length}) - ₹${totalSelectedAmount.toStringAsFixed(2)}",
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                  if (_selectedIndices.isNotEmpty && totalSelectedAmount > 0) ...[
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: OutlinedButton.icon(
                        onPressed: () => _showPartialPaymentSheet(
                          context: context,
                          title: 'Pay Partial (${_selectedIndices.length} Selected)',
                          maxAmount: totalSelectedAmount,
                          invoices: selectedInvoices,
                        ),
                        icon: const Icon(Icons.pie_chart_outline, size: 18),
                        label: const Text(
                          "PAY PARTIAL AMOUNT",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Color(0xFF00C2CB)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

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
                          _selectedIndices = Set.from(
                            List.generate(state.invoices.length, (index) => index),
                          ); // Select all
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

            // Invoice List with Checkboxes
            ...state.invoices.asMap().entries.map((entry) {
              final index = entry.key;
              final inv = entry.value;
              final isSelected = _selectedIndices.contains(index);
              final statusColor = switch (inv.status.toUpperCase()) {
                'PAID' => Colors.green,
                'PENDING' => Colors.orange,
                'OVERDUE' => Colors.red,
                _ => Colors.blueGrey,
              };
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Invoice: ${inv.invoiceNumber}',
                          style: TextStyle(color: statusColor, fontSize: 13),
                        ),
                        Text(
                          'Due: ${inv.dueDate.day}/${inv.dueDate.month}/${inv.dueDate.year}',
                          style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                        ),
                      ],
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
                            "₹${inv.totalAmount.toStringAsFixed(2)}",
                            style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              inv.status,
                              style: TextStyle(
                                fontSize: 11,
                                color: statusColor,
                                fontWeight: FontWeight.w600,
                              ),
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
      },
    );
  }

  void _showPartialPaymentSheet({
    required BuildContext context,
    required String title,
    required double maxAmount,
    required List<InvoiceItem> invoices,
  }) {
    final TextEditingController amountController = TextEditingController(
      text: (maxAmount / 2).toStringAsFixed(0),
    );
    String? errorText;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (sheetContext, setSheetState) {
          void applyPercentage(double fraction) {
            final calculated = (maxAmount * fraction);
            amountController.text = calculated.toStringAsFixed(2);
            setSheetState(() => errorText = null);
          }

          void submitPartial() {
            final parsed = double.tryParse(amountController.text.trim());
            if (parsed == null || parsed <= 0) {
              setSheetState(() => errorText = 'Enter a valid amount greater than ₹0');
              return;
            }
            if (parsed > maxAmount) {
              setSheetState(
                    () => errorText = 'Amount cannot exceed ₹${maxAmount.toStringAsFixed(2)}',
              );
              return;
            }
            Navigator.pop(ctx);
            _onProceedPayment(
              amount: parsed,
              isPartial: parsed < maxAmount,
              invoices: invoices,
            );
          }

          return SafeArea(
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              padding: EdgeInsets.fromLTRB(
                20,
                14,
                20,
                20 + MediaQuery.of(ctx).viewInsets.bottom,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Container(
                        width: 42,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.border,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Maximum payable: ₹${maxAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: amountController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      autofocus: true,
                      decoration: InputDecoration(
                        labelText: 'Enter Amount (₹)',
                        prefixText: '₹ ',
                        errorText: errorText,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onChanged: (_) {
                        if (errorText != null) {
                          setSheetState(() => errorText = null);
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        for (final pct in [25, 50, 75]) ...[
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => applyPercentage(pct / 100),
                              child: Text('$pct%'),
                            ),
                          ),
                          if (pct != 75) const SizedBox(width: 8),
                        ],
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: submitPartial,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'PROCEED TO PAY',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ).whenComplete(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        amountController.dispose();
      });
    });
  }

  Future<void> _onProceedPayment({
    required double amount,
    required bool isPartial,
    required List<InvoiceItem> invoices,
  }) async {
    if (!mounted) return;

    final result = await context.push<PaymentCheckoutResult>(
      '/payment-checkout', // or AppRouter.paymentCheckout
      extra: PaymentCheckoutArgs(
        payableAmount: amount,
        isPartial: isPartial,
        invoices: invoices,
        onPaymentConfirm: (checkoutResult) {
          // TODO: Dispatch event to AccountingBloc
          // widget.accountingBloc.add(SubmitPaymentEvent(checkoutResult));
          debugPrint(
            'Confirmed -> Total: ₹${checkoutResult.finalTotal.toStringAsFixed(2)}, '
                'Method: ${checkoutResult.method.name}, Ref: ${checkoutResult.paymentReference}, '
                'Partial: ${checkoutResult.isPartial}',
          );
        },
      ),
    );

    if (result != null && mounted) {
      // Optional: refresh dues / clear selection or show confirmation
      debugPrint('Returned from checkout with ref: ${result.paymentReference}');
    }
  }

  void _showInvoiceDetails(BuildContext context, InvoiceItem item) {
    final statusColor = switch (item.status.toUpperCase()) {
      'PAID' => AppColors.success,
      'PENDING' => AppColors.warning,
      'OVERDUE' => AppColors.error,
      _ => AppColors.textSecondary,
    };
    final bool isPaid = item.status.toUpperCase() == 'PAID';

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => SafeArea(
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(ctx).size.height * 0.85,
          ),
          decoration: const BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              20,
              12,
              20,
              20 + MediaQuery.of(ctx).viewInsets.bottom,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        item.status,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Invoice ${item.invoiceNumber}',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'TOTAL PAYABLE',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '₹${item.totalAmount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                _invoiceDetailRow(
                  Icons.calendar_today_outlined,
                  'Due date',
                  '${item.dueDate.day}/${item.dueDate.month}/${item.dueDate.year}',
                ),
                _invoiceDetailRow(
                  Icons.receipt_long_outlined,
                  'Billing month',
                  item.billingMonth,
                ),
                _invoiceDetailRow(
                  Icons.home_outlined,
                  'Flat / Building',
                  '${item.flatId} / ${item.buildingId}',
                ),
                _invoiceDetailRow(
                  Icons.payments_outlined,
                  'Invoice DueAmount',
                  '₹${item.dueAmount.toStringAsFixed(2)}',
                ),
                _invoiceDetailRow(
                  Icons.warning_amber_outlined,
                  'Penalty',
                  '₹${item.penaltyAmount.toStringAsFixed(2)}',
                ),
                _invoiceDetailRow(
                  Icons.info_outline,
                  'Penalty Reason',
                  '${item.penaltyReason}',
                ),
                if (item.description.trim().isNotEmpty) ...[
                  const SizedBox(height: 12),
                  const Text(
                    'Description',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.description,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ],
                const SizedBox(height: 22),
                if (isPaid)
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'CLOSE',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                else
                  Row(
                    children: [
                      if (item.totalAmount > 0) ...[
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.pop(ctx);
                                _showPartialPaymentSheet(
                                  context: context,
                                  title: 'Partial Payment - ${item.title}',
                                  maxAmount: item.totalAmount,
                                  invoices: [item],
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.primary,
                                side: const BorderSide(color: AppColors.primary),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: const Text(
                                'PAY PARTIAL',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(ctx);
                              _onProceedPayment(
                                amount: item.totalAmount,
                                isPartial: false,
                                invoices: [item],
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: const Text(
                              'PAY NOW',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _invoiceDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        children: [
          Icon(icon, size: 19, color: AppColors.textSecondary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}