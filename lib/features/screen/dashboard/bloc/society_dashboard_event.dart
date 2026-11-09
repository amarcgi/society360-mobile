import 'package:equatable/equatable.dart';

abstract class SocietyDashboardEvent extends Equatable {
  const SocietyDashboardEvent();

  @override
  List<Object?> get props => [];
}

class LoadSocietyDashboard extends SocietyDashboardEvent {
  final String mobile;

  const LoadSocietyDashboard(this.mobile);

  @override
  List<Object?> get props => [mobile];
}