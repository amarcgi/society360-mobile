import 'package:bloc/bloc.dart';

import '../model/invoice_Item.dart';
import 'accounting_event.dart';

class AccountingBloc extends Bloc<AccountingEvent, AccountingState> {
  AccountingBloc() : super(AccountingState([])) {
    on<LoadAccounting>((event, emit) {
      emit(AccountingState([
        InvoiceItem(title: "Water Charges", status: "Overdue", amount: 1700, dueDate: DateTime(2026, 5, 31), description: "Water Bill charges for APartment and Fine indtroduced against ur flat.", invoiceNo: "INV-001", flatNo: "301", buildingNo: "B"),
        InvoiceItem(title: "Maintenance", status: "Pending", amount: 2500, dueDate: DateTime(2026, 6, 5), description: "Monthly fee against Maintenance.", invoiceNo: "INV-002", flatNo: "301", buildingNo: "B"),
        InvoiceItem(title: "Maintenance", status: "PAID", amount: 2500, dueDate: DateTime(2026, 6, 5), description: "Monthly fee.", invoiceNo: "INV-002", flatNo: "301", buildingNo: "B"),
        InvoiceItem(title: "Maintenance", status: "Pending", amount: 2500, dueDate: DateTime(2026, 6, 5), description: "Monthly fee.", invoiceNo: "INV-002", flatNo: "301", buildingNo: "B"),
        InvoiceItem(title: "Maintenance", status: "Pending", amount: 2500, dueDate: DateTime(2026, 6, 5), description: "Monthly fee.", invoiceNo: "INV-002", flatNo: "301", buildingNo: "B"),
        InvoiceItem(title: "Maintenance", status: "Pending", amount: 2500, dueDate: DateTime(2026, 6, 5), description: "Monthly fee.", invoiceNo: "INV-002", flatNo: "301", buildingNo: "B"),
        InvoiceItem(title: "Maintenance", status: "Pending", amount: 2500, dueDate: DateTime(2026, 6, 5), description: "Monthly fee.", invoiceNo: "INV-002", flatNo: "301", buildingNo: "B"),
        InvoiceItem(title: "Maintenance", status: "Pending", amount: 2500, dueDate: DateTime(2026, 6, 5), description: "Monthly fee.", invoiceNo: "INV-002", flatNo: "301", buildingNo: "B"),
        InvoiceItem(title: "Maintenance", status: "Pending", amount: 2500, dueDate: DateTime(2026, 6, 5), description: "Monthly fee.", invoiceNo: "INV-002", flatNo: "301", buildingNo: "B"),
        InvoiceItem(title: "Maintenance", status: "Pending", amount: 2500, dueDate: DateTime(2026, 6, 5), description: "Monthly fee.", invoiceNo: "INV-002", flatNo: "301", buildingNo: "B"),
        InvoiceItem(title: "Maintenance", status: "Pending", amount: 2500, dueDate: DateTime(2026, 6, 5), description: "Monthly fee.", invoiceNo: "INV-002", flatNo: "301", buildingNo: "B"),
        InvoiceItem(title: "Maintenance", status: "Pending", amount: 2500, dueDate: DateTime(2026, 6, 5), description: "Monthly fee.", invoiceNo: "INV-002", flatNo: "301", buildingNo: "B"),
        InvoiceItem(title: "Maintenance", status: "Pending", amount: 2500, dueDate: DateTime(2026, 6, 5), description: "Monthly fee.", invoiceNo: "INV-002", flatNo: "301", buildingNo: "B"),
        InvoiceItem(title: "Maintenance", status: "Pending", amount: 2500, dueDate: DateTime(2026, 6, 5), description: "Monthly fee.", invoiceNo: "INV-002", flatNo: "301", buildingNo: "B"),
        InvoiceItem(title: "Maintenance", status: "Pending", amount: 2500, dueDate: DateTime(2026, 6, 5), description: "Monthly fee.", invoiceNo: "INV-002", flatNo: "301", buildingNo: "B"),
        InvoiceItem(title: "Maintenance", status: "Pending", amount: 2500, dueDate: DateTime(2026, 6, 5), description: "Monthly fee.", invoiceNo: "INV-002", flatNo: "301", buildingNo: "B"),
        InvoiceItem(title: "Maintenance", status: "Pending", amount: 2500, dueDate: DateTime(2026, 6, 5), description: "Monthly fee.", invoiceNo: "INV-002", flatNo: "301", buildingNo: "B"),
        InvoiceItem(title: "Maintenance", status: "Pending", amount: 2500, dueDate: DateTime(2026, 6, 5), description: "Monthly fee.", invoiceNo: "INV-002", flatNo: "301", buildingNo: "B"),


      ]));
    });
  }
}