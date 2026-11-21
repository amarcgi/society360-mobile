import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/shared/widgets/app_bar.dart';
import '../../../core/theme/AppColors.dart';
import 'model/invoice_Item.dart';

enum PaymentMethod { upi, card, netBanking }

class PaymentCheckoutResult {
  final double payableAmount;
  final double gatewayFee;
  final double finalTotal;
  final bool isPartial;
  final PaymentMethod method;
  final String? paymentReference;
  final List<InvoiceItem> invoices;

  const PaymentCheckoutResult({
    required this.payableAmount,
    required this.gatewayFee,
    required this.finalTotal,
    required this.isPartial,
    required this.method,
    required this.invoices,
    this.paymentReference,
  });
}

class PaymentCheckoutScreen extends StatefulWidget {
  final double payableAmount;
  final bool isPartial;
  final List<InvoiceItem> invoices;
  final double gatewayFeePercentage;
  final void Function(PaymentCheckoutResult result)? onPaymentConfirm;

  const PaymentCheckoutScreen({
    super.key,
    required this.payableAmount,
    required this.isPartial,
    required this.invoices,
    this.gatewayFeePercentage = 0.0, // Set e.g. 1.5 if charging convenience fee
    this.onPaymentConfirm,
  });

  @override
  State<PaymentCheckoutScreen> createState() => _PaymentCheckoutScreenState();
}

class _PaymentCheckoutScreenState extends State<PaymentCheckoutScreen> {
  PaymentMethod _selectedMethod = PaymentMethod.upi;

  // UPI fields
  final TextEditingController _upiIdController = TextEditingController();
  String _selectedUpiApp = 'GPay';
  final List<String> _upiApps = ['GPay', 'PhonePe', 'Paytm', 'BHIM'];

  // Card fields
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _cardHolderController = TextEditingController();

  // NetBanking field
  String _selectedBank = 'HDFC Bank';
  final List<String> _banks = [
    'HDFC Bank',
    'ICICI Bank',
    'State Bank of India (SBI)',
    'Axis Bank',
    'Kotak Mahindra Bank',
  ];

  String? _validationError;
  bool _isProcessing = false;

  double get _invoicesBaseTotal =>
      widget.invoices.fold(0.0, (sum, item) => sum + item.dueAmount);

  double get _invoicesPenaltyTotal =>
      widget.invoices.fold(0.0, (sum, item) => sum + item.penaltyAmount);

  double get _gatewayFee =>
      (widget.payableAmount * widget.gatewayFeePercentage) / 100.0;

  double get _finalTotal => widget.payableAmount + _gatewayFee;

  @override
  void dispose() {
    _upiIdController.dispose();
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _cardHolderController.dispose();
    super.dispose();
  }

  bool _validatePaymentInput() {
    setState(() => _validationError = null);

    if (_selectedMethod == PaymentMethod.upi) {
      final upi = _upiIdController.text.trim();
      // If user typed a UPI ID, validate basic format; otherwise allow quick app selection
      if (upi.isNotEmpty && !RegExp(r'^[\w.\-]+@[\w]+$').hasMatch(upi)) {
        setState(() => _validationError = 'Enter a valid UPI ID (e.g. name@okaxis)');
        return false;
      }
      return true;
    }

    if (_selectedMethod == PaymentMethod.card) {
      final digitsOnly = _cardNumberController.text.replaceAll(RegExp(r'\s+'), '');
      if (digitsOnly.length < 12 || digitsOnly.length > 19) {
        setState(() => _validationError = 'Enter a valid card number');
        return false;
      }
      if (!RegExp(r'^(0[1-9]|1[0-2])\/\d{2}$').hasMatch(_expiryController.text.trim())) {
        setState(() => _validationError = 'Enter expiry in MM/YY format');
        return false;
      }
      final cvv = _cvvController.text.trim();
      if (cvv.length < 3 || cvv.length > 4) {
        setState(() => _validationError = 'Enter a valid 3 or 4 digit CVV');
        return false;
      }
      if (_cardHolderController.text.trim().isEmpty) {
        setState(() => _validationError = 'Enter cardholder name');
        return false;
      }
      return true;
    }

    if (_selectedMethod == PaymentMethod.netBanking) {
      if (_selectedBank.isEmpty) {
        setState(() => _validationError = 'Please select a bank');
        return false;
      }
      return true;
    }

    return false;
  }

  Future<void> _handleFinalPay() async {
    if (!_validatePaymentInput()) return;

    setState(() => _isProcessing = true);

    String? reference;
    if (_selectedMethod == PaymentMethod.upi) {
      reference = _upiIdController.text.trim().isNotEmpty
          ? _upiIdController.text.trim()
          : _selectedUpiApp;
    } else if (_selectedMethod == PaymentMethod.card) {
      final digits = _cardNumberController.text.replaceAll(RegExp(r'\s+'), '');
      final last4 = digits.length >= 4 ? digits.substring(digits.length - 4) : digits;
      reference = 'Card •••• $last4';
    } else {
      reference = _selectedBank;
    }

    final result = PaymentCheckoutResult(
      payableAmount: widget.payableAmount,
      gatewayFee: _gatewayFee,
      finalTotal: _finalTotal,
      isPartial: widget.isPartial,
      method: _selectedMethod,
      paymentReference: reference,
      invoices: widget.invoices,
    );

    // Simulate brief handoff or let parent/BLoC handle gateway
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;

    setState(() => _isProcessing = false);
    widget.onPaymentConfirm?.call(result);

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 28),
            SizedBox(width: 10),
            Text('Payment Initiated'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Amount: ₹${_finalTotal.toStringAsFixed(2)}'),
            const SizedBox(height: 6),
            Text('Method: ${_methodLabel(_selectedMethod)}'),
            if (reference != null) ...[
              const SizedBox(height: 6),
              Text('Details: $reference'),
            ],
            const SizedBox(height: 6),
            Text('Invoices: ${widget.invoices.length}'),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogCtx); // Close dialog
              Navigator.pop(context, result); // Return result to previous screen
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('DONE'),
          ),
        ],
      ),
    );
  }

  String _methodLabel(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.upi:
        return 'UPI';
      case PaymentMethod.card:
        return 'Credit / Debit Card';
      case PaymentMethod.netBanking:
        return 'NetBanking';
    }
  }

  @override
  Widget build(BuildContext context) {
    final double differenceFromSelected = _invoicesBaseTotal - widget.payableAmount;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBars.customAppBar(
        context: context,
        title: 'Payment',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Complete Payment Breakup Card
              _buildBreakupCard(differenceFromSelected),
              const SizedBox(height: 20),

              // 2. Payment Method Selector
              const Text(
                'SELECT PAYMENT METHOD',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary,
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: 10),
              _buildMethodSelectorTiles(),
              const SizedBox(height: 14),

              // 3. Method-Specific Form Inputs
              _buildMethodDetailsForm(),

              if (_validationError != null) ...[
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red.withOpacity(0.4)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _validationError!,
                          style: const TextStyle(color: Colors.red, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 24),

              // 4. Final Payment Button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _isProcessing ? null : _handleFinalPay,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00C2CB),
                    foregroundColor: Colors.black,
                    disabledBackgroundColor: Colors.grey.shade400,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: _isProcessing
                      ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.black,
                    ),
                  )
                      : Text(
                    'PAY FINAL ₹${_finalTotal.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBreakupCard(double differenceFromSelected) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Payment Breakup',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: widget.isPartial
                      ? Colors.orange.withOpacity(0.14)
                      : Colors.green.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  widget.isPartial ? 'PARTIAL PAYMENT' : 'FULL PAYMENT',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: widget.isPartial ? Colors.orange.shade800 : Colors.green.shade800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Included invoices summary
          ...widget.invoices.map(
                (inv) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${inv.title} (${inv.invoiceNumber})',
                      style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '₹${inv.dueAmount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const Divider(height: 20),

          _breakupRow('Selected Dues Subtotal', '₹${_invoicesBaseTotal.toStringAsFixed(2)}'),
          if (_invoicesPenaltyTotal > 0)
            _breakupRow(
              'Recorded Invoice Penalties',
              '₹${_invoicesPenaltyTotal.toStringAsFixed(2)}',
            ),
          if (widget.isPartial && differenceFromSelected > 0)
            _breakupRow(
              'Remaining Balance After Payment',
              '-₹${differenceFromSelected.toStringAsFixed(2)}',
              valueColor: Colors.orange.shade800,
            ),
          _breakupRow(
            'Selected Payment Amount',
            '₹${widget.payableAmount.toStringAsFixed(2)}',
          ),
          _breakupRow(
            'Gateway / Convenience Fee',
            _gatewayFee == 0 ? '₹0.00 (Free)' : '₹${_gatewayFee.toStringAsFixed(2)}',
          ),

          const Divider(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Net Payable Amount',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '₹${_finalTotal.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F2D52),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _breakupRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: valueColor ?? AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMethodSelectorTiles() {
    return Column(
      children: [
        _methodCard(
          method: PaymentMethod.upi,
          icon: Icons.qr_code_2,
          title: 'UPI',
          subtitle: 'GPay, PhonePe, Paytm, BHIM or UPI ID',
        ),
        const SizedBox(height: 8),
        _methodCard(
          method: PaymentMethod.card,
          icon: Icons.credit_card,
          title: 'Credit / Debit Card',
          subtitle: 'Visa, Mastercard, RuPay',
        ),
        const SizedBox(height: 8),
        _methodCard(
          method: PaymentMethod.netBanking,
          icon: Icons.account_balance,
          title: 'NetBanking',
          subtitle: 'All major Indian banks supported',
        ),
      ],
    );
  }

  Widget _methodCard({
    required PaymentMethod method,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final bool selected = _selectedMethod == method;
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {
        setState(() {
          _selectedMethod = method;
          _validationError = null;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? const Color(0xFF0F2D52) : AppColors.border,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF0F2D52)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Radio<PaymentMethod>(
              value: method,
              groupValue: _selectedMethod,
              activeColor: const Color(0xFF0F2D52),
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    _selectedMethod = val;
                    _validationError = null;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMethodDetailsForm() {
    switch (_selectedMethod) {
      case PaymentMethod.upi:
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Quick UPI App',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _upiApps.map((app) {
                  final active = _selectedUpiApp == app && _upiIdController.text.trim().isEmpty;
                  return ChoiceChip(
                    label: Text(app),
                    selected: active,
                    selectedColor: const Color(0xFF00C2CB).withOpacity(0.25),
                    onSelected: (_) {
                      setState(() {
                        _selectedUpiApp = app;
                        _upiIdController.clear();
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _upiIdController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Or Enter UPI ID',
                  hintText: 'yourname@okaxis',
                  prefixIcon: const Icon(Icons.alternate_email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (_) => setState(() {}),
              ),
            ],
          ),
        );

      case PaymentMethod.card:
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              TextField(
                controller: _cardNumberController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  labelText: 'Card Number',
                  hintText: '1234 5678 9012 3456',
                  prefixIcon: const Icon(Icons.credit_card),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _expiryController,
                      keyboardType: TextInputType.datetime,
                      decoration: InputDecoration(
                        labelText: 'Expiry (MM/YY)',
                        hintText: '08/29',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _cvvController,
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                      ],
                      decoration: InputDecoration(
                        labelText: 'CVV',
                        hintText: '123',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _cardHolderController,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: 'Cardholder Name',
                  hintText: 'Name on card',
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        );

      case PaymentMethod.netBanking:
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: DropdownButtonFormField<String>(
            value: _selectedBank,
            decoration: InputDecoration(
              labelText: 'Select Bank',
              prefixIcon: const Icon(Icons.account_balance),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            items: _banks
                .map((bank) => DropdownMenuItem(value: bank, child: Text(bank)))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => _selectedBank = value);
              }
            },
          ),
        );
    }
  }
}