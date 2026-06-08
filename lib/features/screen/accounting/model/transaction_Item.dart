class TransactionItem {
  final String title;
  final double amount;
  final DateTime date;
  final String type; // 'Credit' or 'Debit'

  TransactionItem({required this.title, required this.amount, required this.date, required this.type});
}