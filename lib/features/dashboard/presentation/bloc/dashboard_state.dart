import '../../data/models/dashboard_model.dart';

abstract class DashboardState {}

class DashboardInitial extends DashboardState {}
class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final CashflowSummary cashflow;
  final DevisStats      devisStats;

  DashboardLoaded({
    required this.cashflow,
    required this.devisStats,
  });
}

class DashboardError extends DashboardState {
  final String message;
  DashboardError(this.message);
}