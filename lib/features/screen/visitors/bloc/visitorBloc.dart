import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:society360_app/features/screen/visitors/bloc/visitorEvent.dart';
import 'package:society360_app/features/screen/visitors/bloc/visitorState.dart';

class VisitorBloc extends Bloc<VisitorEvent, VisitorState> {
  VisitorBloc() : super(VisitorInitial()) {
    on<LoadVisitors>(_onLoadVisitors);
    on<AddNewVisitor>(_onAddNewVisitor);
    on<ChangeFilterChip>(_onChangeFilterChip);
    on<UpdateGateDecision>(_onUpdateGateDecision);
  }

  Future<void> _onLoadVisitors(LoadVisitors event, Emitter<VisitorState> emit) async {
    emit(VisitorLoading());
    try {
      // Simulating network API latency fetch
      await Future.delayed(const Duration(milliseconds: 800));

      emit(const VisitorLoaded(
        insideVisitors: [
          {'id': '1', 'name': 'Rajesh Kumar', 'sub': 'Plumber • Inside since 10:30 AM', 'type': 'Inside'},
          {'id': '2', 'name': 'Priya Sharma', 'sub': 'Guest • Inside since 11:15 AM', 'type': 'Inside'}
        ],
        expectedVisitors: [
          {'id': '3', 'name': 'Delivery Vikas', 'sub': 'Delivery • Expected', 'type': 'Expected'}
        ],
        historyVisitors: [
          {'name': 'Rakesh Kumar', 'sub': 'Plumber • Checked out 01:20 PM'},
          {'name': 'Mohan Joshi', 'sub': 'Maid Staff • Checked out 06:00 PM'}
        ],
      ));
    } catch (e) {
      emit(const VisitorError('Failed to synchronize society grid profile logs.'));
    }
  }

  Future<void> _onAddNewVisitor(AddNewVisitor event, Emitter<VisitorState> emit) async {
    if (state is VisitorLoaded) {
      final currentState = state as VisitorLoaded;
      emit(VisitorLoading());

      // Simulating server push post mutation
      await Future.delayed(const Duration(milliseconds: 500));

      final updatedExpected = List<Map<String, dynamic>>.from(currentState.expectedVisitors)
        ..add(event.visitorDetails);

      emit(currentState.copyWith(expectedVisitors: updatedExpected));
    }
  }

  void _onChangeFilterChip(ChangeFilterChip event, Emitter<VisitorState> emit) {
    if (state is VisitorLoaded) {
      final currentState = state as VisitorLoaded;
      emit(currentState.copyWith(activeFilter: event.selectedFilter));
    }
  }

  Future<void> _onUpdateGateDecision(UpdateGateDecision event, Emitter<VisitorState> emit) async {
    // Implement edge decision updates here (e.g., removing a waiting delivery worker and transferring them to history log)
  }
}