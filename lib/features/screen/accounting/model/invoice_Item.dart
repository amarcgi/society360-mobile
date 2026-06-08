class InvoiceItem {
  final String title, status, description, invoiceNo, flatNo, buildingNo;
  final double amount;
  final DateTime dueDate;
  InvoiceItem({required this.title, required this.status, required this.amount, required this.dueDate,
    required this.description, required this.invoiceNo, required this.flatNo, required this.buildingNo});
}