class InvoiceItem {
  final double dueAmount;
  final String billingMonth;
  final int buildingId;
  final DateTime? createdAt;
  final String description;
  final DateTime dueDate;
  final int flatId;
  final int invoiceId;
  final String invoiceNumber;
  final DateTime? invoiceGeneratedAt;
  final double penaltyAmount;
  final String? penaltyReason;
  final String societyId;
  final String status;
  final double totalDueAmount;
  final double paidAmount;
  final double balanceAmount;
  final String type;
  final String invoiceGeneratedBy;

  const InvoiceItem({
    required this.dueAmount,
    required this.billingMonth,
    required this.buildingId,
    this.createdAt,
    required this.description,
    required this.dueDate,
    required this.flatId,
    required this.invoiceId,
    required this.invoiceNumber,
    this.invoiceGeneratedAt,
    required this.penaltyAmount,
    this.penaltyReason,
    required this.societyId,
    required this.status,
    required this.totalDueAmount,
    required this.paidAmount,
    required this.balanceAmount,
    required this.type,
    required this.invoiceGeneratedBy,
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
      dueAmount: readDouble('dueAmount'),
      billingMonth: json['billingMonth']?.toString() ?? '',
      buildingId: readInt('buildingId'),
      createdAt: readOptionalDate('createdAt'),
      description: json['description']?.toString() ?? '',
      dueDate: readDate('dueDate'),
      flatId: readInt('flatId'),
      invoiceId: readInt('invoiceId'),
      invoiceNumber: json['invoiceNumber']?.toString() ?? '',
      invoiceGeneratedAt: readOptionalDate('invoice_generated_at '),
      penaltyAmount: readDouble('penaltyAmount'),
      penaltyReason: json['penaltyReason']?.toString() ?? '',
      societyId: json['societyId']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      totalDueAmount: readDouble('total_due_amount'),
      type: json['type']?.toString() ?? '',
      paidAmount: readDouble('paidAmount'),
      balanceAmount: readDouble('balanceAmount'),
      invoiceGeneratedBy: json['invoice_generated_by']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'dueAmount': dueAmount,
    'billingMonth': billingMonth,
    'buildingId': buildingId,
    'createdAt': createdAt?.toIso8601String(),
    'description': description,
    'dueDate': dueDate.toIso8601String().split('T').first,
    'flatId': flatId,
    'invoiceId': invoiceId,
    'invoiceNumber': invoiceNumber,
    'invoiceGeneratedAt': invoiceGeneratedAt?.toIso8601String(),
    'penaltyAmount': penaltyAmount,
    'penaltyReason': penaltyReason,
    'societyId': societyId,
    'status': status,
    'totalDueAmount': totalDueAmount,
    'type': type,
    'paidAmount': paidAmount,
    'balanceAmount': balanceAmount,
    'invoiceGeneratedBy': invoiceGeneratedBy,
  };
}