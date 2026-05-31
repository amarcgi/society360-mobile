import 'package:equatable/equatable.dart';

abstract class VisitorState extends Equatable {
  const VisitorState();

  @override
  List<Object?> get props => [];
}

// 1. Initial State
class VisitorInitial extends VisitorState {}

// 2. Loading State (Displays Progress Indicators)
class VisitorLoading extends VisitorState {}

// 3. Loaded State (Displays operational UI data)
class VisitorLoaded extends VisitorState {
  final List<Map<String, dynamic>> insideVisitors;
  final List<Map<String, dynamic>> expectedVisitors;
  final List<Map<String, dynamic>> historyVisitors;
  final String activeFilter; // 'All', 'Inside', 'Checked out', etc.

  const VisitorLoaded({
    required this.insideVisitors,
    required this.expectedVisitors,
    required this.historyVisitors,
    this.activeFilter = 'All',
  });

  VisitorLoaded copyWith({
    List<Map<String, dynamic>>? insideVisitors,
    List<Map<String, dynamic>>? expectedVisitors,
    List<Map<String, dynamic>>? historyVisitors,
    String? activeFilter,
  }) {
    return VisitorLoaded(
      insideVisitors: insideVisitors ?? this.insideVisitors,
      expectedVisitors: expectedVisitors ?? this.expectedVisitors,
      historyVisitors: historyVisitors ?? this.historyVisitors,
      activeFilter: activeFilter ?? this.activeFilter,
    );
  }

  @override
  List<Object?> get props => [insideVisitors, expectedVisitors, historyVisitors, activeFilter];
}

// 4. Error State (Displays Snackbar alerts or Retry screens)
class VisitorError extends VisitorState {
  final String errorMessage;
  const VisitorError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}