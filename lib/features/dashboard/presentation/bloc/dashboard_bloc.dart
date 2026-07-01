import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasources/dashboard_remote_datasource.dart';
import '../../data/models/dashboard_model.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRemoteDataSource dataSource;

  DashboardBloc(this.dataSource) : super(DashboardInitial()) {
    on<LoadDashboard>(_onLoadDashboard);
    on<RefreshDashboard>(_onLoadDashboard);
  }

  Future<void> _onLoadDashboard(
      DashboardEvent event,
      Emitter<DashboardState> emit,
      ) async {
    emit(DashboardLoading());
    try {
      final results = await Future.wait([
        dataSource.getCashflowSummary(),
        dataSource.getDevisStats(),
      ]);

      emit(DashboardLoaded(
        cashflow:   results[0] as CashflowSummary,
        devisStats: results[1] as DevisStats,
      ));
    } catch (e) {
      emit(DashboardError('Erreur : ${e.toString()}'));
    }
  }
}