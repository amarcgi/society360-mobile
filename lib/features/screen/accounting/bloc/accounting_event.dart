import '../model/invoice_Item.dart';

class AccountingEvent {}
class LoadAccounting extends AccountingEvent {}
class AccountingState {
  final List<InvoiceItem> invoices;
  AccountingState(this.invoices);
}