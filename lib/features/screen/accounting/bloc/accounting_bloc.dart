import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories/accounting_repository_impl.dart';
import 'accounting_event.dart';
import 'accounting_state.dart';

class AccountingBloc extends Bloc<AccountingEvent, AccountingState> {
  final AccountingRepository _repository;

  AccountingBloc(this._repository)
      : super(const AccountingState()) {
    on<LoadAccounting>(_onLoadAccounting);
  }

  Future<void> _onLoadAccounting(
      LoadAccounting event,
      Emitter<AccountingState> emit,
      ) async {
    emit(state.copyWith(status: AccountingStatus.loading));

    try {
      final invoices = await _repository.getInvoices(flatId: event.flatId, societyId: event.societyId, buildingId: event.buildingId, mobileNo: event.mobileNo);
      emit(AccountingState(
        status: AccountingStatus.success,
        invoices: invoices,
      ));
    } on DioException catch (error) {
      final response = error.response?.data;
      final message = response is Map
          ? response['message']?.toString()
          : null;

      emit(AccountingState(
        status: AccountingStatus.failure,
        errorMessage: message ?? error.message ?? 'Failed to load invoices',
      ));
    } on FormatException catch (error) {
      emit(AccountingState(
        status: AccountingStatus.failure,
        errorMessage: error.message,
      ));
    }
  }
}