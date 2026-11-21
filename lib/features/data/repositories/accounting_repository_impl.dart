import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../../screen/accounting/model/invoice_Item.dart';


abstract class AccountingRepository {
  Future<List<InvoiceItem>> getInvoices({required flatId,required societyId,required buildingId});
}

class AccountingRepositoryImpl implements AccountingRepository {
  final Dio _dio;

  AccountingRepositoryImpl() : _dio = ApiClient().dio;

  @override
  Future<List<InvoiceItem>> getInvoices({required flatId,required societyId,required buildingId}) async {
    final path = '${ApiConstants.invoices}'
        '/society/${Uri.encodeComponent(societyId.toString())}'
        '/building/${Uri.encodeComponent(buildingId.toString())}'
        '/flat/${Uri.encodeComponent(flatId.toString())}' ;

    final response = await _dio.get(path);

    dynamic payload = response.data;
    if (payload is Map) {
      payload = payload['data'] ?? payload['invoices'] ?? payload['content'];
    }

    if (payload is! List) {
      throw const FormatException('Unexpected invoices response format');
    }

    return payload
        .map((item) => InvoiceItem.fromJson(
      Map<String, dynamic>.from(item as Map),
    ))
        .toList();
  }
}