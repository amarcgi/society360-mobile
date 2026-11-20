import 'package:equatable/equatable.dart';

abstract class AccountingEvent extends Equatable {
  const AccountingEvent();

  @override
  List<Object?> get props => [];
}

class LoadAccounting extends AccountingEvent {
  final String flatId;
  final String societyId;
  final String buildingId;
  final String mobileNo;


  const LoadAccounting({required this.flatId,required this.societyId,required this.buildingId,required this.mobileNo});

  @override
  List<Object?> get props => [flatId, societyId, buildingId, mobileNo];
}