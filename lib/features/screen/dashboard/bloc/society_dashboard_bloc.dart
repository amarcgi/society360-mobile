import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../model/society_dashboard_response.dart';
import 'society_dashboard_event.dart';
import 'society_dashboard_state.dart';

class SocietyDashboardBloc
    extends Bloc<SocietyDashboardEvent, SocietyDashboardState> {
  SocietyDashboardBloc() : super(const SocietyDashboardInitial()) {
    on<LoadSocietyDashboard>(_onLoadDashboard);
  }

  Future<void> _onLoadDashboard(
      LoadSocietyDashboard event,
      Emitter<SocietyDashboardState> emit,
      ) async {
    emit(const SocietyDashboardLoading());

    try {
      final response = await ApiClient().dio.get(
        '${ApiConstants.dashBoard}${Uri.encodeComponent(event.mobile)}',
      );

      final data = response.data;
      if (data is! Map) {
        throw const FormatException(
          'Unexpected response while loading dashboard',
        );
      }

      emit(
        SocietyDashboardLoaded(
          SocietyDashBoardDetails.fromJson(
            Map<String, dynamic>.from(data),
          ),
        ),
      );
    } on DioException catch (error) {
      final responseData = error.response?.data;
      final message = responseData is Map
          ? responseData['message']?.toString()
          : null;

      emit(SocietyDashboardFailure(
        message ?? error.message ?? 'Failed to load dashboard',
      ));
    } on FormatException catch (error) {
      emit(SocietyDashboardFailure(error.message));
    }
  }
}