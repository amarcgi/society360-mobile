import 'package:equatable/equatable.dart';
import '../model/society_dashboard_response.dart';

abstract class SocietyDashboardState extends Equatable {
  const SocietyDashboardState();

  @override
  List<Object?> get props => [];
}

class SocietyDashboardInitial extends SocietyDashboardState {
  const SocietyDashboardInitial();
}

class SocietyDashboardLoading extends SocietyDashboardState {
  const SocietyDashboardLoading();
}

class SocietyDashboardLoaded extends SocietyDashboardState {
  final SocietyDashBoardDetails details;

  const SocietyDashboardLoaded(this.details);

  @override
  List<Object?> get props => [details];
}

class SocietyDashboardFailure extends SocietyDashboardState {
  final String message;

  const SocietyDashboardFailure(this.message);

  @override
  List<Object?> get props => [message];
}