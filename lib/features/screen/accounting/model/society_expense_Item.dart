class SocietyExpenseItem {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final String type; // 'Debit' or 'Credit'
  final String description;
  final String txnNo;

  SocietyExpenseItem({
    required this.id, required this.title, required this.amount,
    required this.date, required this.type, required this.description,
    required this.txnNo
  });
}