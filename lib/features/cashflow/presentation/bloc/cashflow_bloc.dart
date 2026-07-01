import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasources/cashflow_remote_datasource.dart';
import '../../data/models/transaction_model.dart';
import 'cashflow_event.dart';
import 'cashflow_state.dart';

class CashflowBloc extends Bloc<CashflowEvent, CashflowState> {
  final CashflowRemoteDataSource _datasource;

  CashflowBloc(this._datasource) : super(CashflowInitial()) {

    on<LoadDashboard>((event, emit) async {
      emit(CashflowLoading());
      try {
        final dashboard = await _datasource.getDashboard();
        emit(DashboardLoaded(dashboard));
      } catch (e) {
        emit(CashflowError(e.toString()));
      }
    });

    on<LoadTransactions>((event, emit) async {
      if (!event.isLoadMore) {
        emit(CashflowLoading());
      } else {
        final current = state is TransactionsLoaded
            ? (state as TransactionsLoaded).transactions
            : <TransactionModel>[];
        emit(TransactionLoadingMore(current));
      }
      try {
        final result = await _datasource.getAllPaginated(
          type:      event.type,
          categorie: event.categorie,
          dateDebut: event.dateDebut,
          dateFin:   event.dateFin,
          page:      event.page,
        );
        final newT = result['transactions'] as List<TransactionModel>;
        if (event.isLoadMore && state is TransactionLoadingMore) {
          final existing = (state as TransactionLoadingMore).current;
          emit(TransactionsLoaded(
            transactions: [...existing, ...newT],
            hasMore:      result['hasNext'],
            currentPage:  event.page,
          ));
        } else {
          emit(TransactionsLoaded(
            transactions: newT,
            hasMore:      result['hasNext'],
            currentPage:  event.page,
          ));
        }
      } catch (e) {
        emit(CashflowError(e.toString()));
      }
    });

    on<AddTransaction>((event, emit) async {
      emit(CashflowLoading());
      try {
        final t = await _datasource.create(event.data);
        emit(TransactionAdded(t));
      } catch (e) {
        emit(CashflowError(e.toString()));
      }
    });

    on<DeleteTransaction>((event, emit) async {
      try {
        await _datasource.delete(event.id);
        emit(TransactionDeleted());
      } catch (e) {
        emit(CashflowError(e.toString()));
      }
    });
  }
}