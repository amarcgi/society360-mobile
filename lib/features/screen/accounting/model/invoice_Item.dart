class InvoiceItem {
  final double amount;
  final String billingMonth;
  final int buildingId;
  final DateTime? createdAt;
  final String description;
  final DateTime dueDate;
  final int flatId;
  final int invoiceId;
  final String invoiceNumber;
  final DateTime? paidAt;
  final double penaltyAmount;
  final String societyId;
  final String status;
  final double totalAmount;
  final String type;

  const InvoiceItem({
    required this.amount,
    required this.billingMonth,
    required this.buildingId,
    this.createdAt,
    required this.description,
    required this.dueDate,
    required this.flatId,
    required this.invoiceId,
    required this.invoiceNumber,
    this.paidAt,
    required this.penaltyAmount,
    required this.societyId,
    required this.status,
    required this.totalAmount,
    required this.type,
  });

  // Compatibility with existing DuesScreen references.
  String get title => type
      .replaceAll('_', ' ')
      .toLowerCase()
      .split(' ')
      .map((word) => word.isEmpty
      ? word
      : '${word[0].toUpperCase()}${word.substring(1)}')
      .join(' ');

  String get invoiceNo => invoiceNumber;
  String get flatNo => flatId.toString();
  String get buildingNo => buildingId.toString();

  factory InvoiceItem.fromJson(Map<String, dynamic> json) {
    double readDouble(String key) {
      final value = json[key];
      if (value is num) return value.toDouble();

      final parsed = double.tryParse(value?.toString() ?? '');
      if (parsed == null) {
        throw FormatException('Invalid or missing invoice field: $key');
      }
      return parsed;
    }

    int readInt(String key) {
      final value = json[key];
      if (value is int) return value;

      final parsed = int.tryParse(value?.toString() ?? '');
      if (parsed == null) {
        throw FormatException('Invalid or missing invoice field: $key');
      }
      return parsed;
    }

    DateTime readDate(String key) {
      final value = json[key];
      final parsed = value == null ? null : DateTime.tryParse(value.toString());
      if (parsed == null) {
        throw FormatException('Invalid or missing invoice field: $key');
      }
      return parsed;
    }

    DateTime? readOptionalDate(String key) {
      final value = json[key];
      return value == null ? null : DateTime.tryParse(value.toString());
    }

    return InvoiceItem(
      amount: readDouble('amount'),
      billingMonth: json['billingMonth']?.toString() ?? '',
      buildingId: readInt('buildingId'),
      createdAt: readOptionalDate('createdAt'),
      description: json['description']?.toString() ?? '',
      dueDate: readDate('dueDate'),
      flatId: readInt('flatId'),
      invoiceId: readInt('invoiceId'),
      invoiceNumber: json['invoiceNumber']?.toString() ?? '',
      paidAt: readOptionalDate('paidAt'),
      penaltyAmount: readDouble('penaltyAmount'),
      societyId: json['societyId']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      totalAmount: readDouble('totalAmount'),
      type: json['type']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'amount': amount,
    'billingMonth': billingMonth,
    'buildingId': buildingId,
    'createdAt': createdAt?.toIso8601String(),
    'description': description,
    'dueDate': dueDate.toIso8601String().split('T').first,
    'flatId': flatId,
    'invoiceId': invoiceId,
    'invoiceNumber': invoiceNumber,
    'paidAt': paidAt?.toIso8601String(),
    'penaltyAmount': penaltyAmount,
    'societyId': societyId,
    'status': status,
    'totalAmount': totalAmount,
    'type': type,
  };
}