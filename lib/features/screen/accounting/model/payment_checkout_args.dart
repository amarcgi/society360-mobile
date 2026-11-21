import '../payment_checkout_screen.dart';
import 'invoice_Item.dart';


class PaymentCheckoutArgs {
  final double payableAmount;
  final bool isPartial;
  final List<InvoiceItem> invoices;
  final double gatewayFeePercentage;
  final void Function(PaymentCheckoutResult result)? onPaymentConfirm;

  const PaymentCheckoutArgs({
    required this.payableAmount,
    required this.isPartial,
    required this.invoices,
    this.gatewayFeePercentage = 0.0,
    this.onPaymentConfirm,
  });
}