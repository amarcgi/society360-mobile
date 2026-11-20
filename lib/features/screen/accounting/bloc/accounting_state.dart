import 'package:equatable/equatable.dart';

import '../model/invoice_Item.dart';

enum AccountingStatus { initial, loading, success, failure }

class AccountingState extends Equatable {
  final AccountingStatus status;
  final List<InvoiceItem> invoices;
  final String? errorMessage;

  const AccountingState({
    this.status = AccountingStatus.initial,
    this.invoices = const [],
    this.errorMessage,
  });

  AccountingState copyWith({
    AccountingStatus? status,
    List<InvoiceItem>? invoices,
    String? errorMessage,
  }) {
    return AccountingState(
      status: status ?? this.status,
      invoices: invoices ?? this.invoices,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, invoices, errorMessage];
}