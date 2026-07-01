import '../../data/models/transaction_model.dart';

abstract class CashflowState {}

class CashflowInitial   extends CashflowState {}
class CashflowLoading   extends CashflowState {}

class DashboardLoaded   extends CashflowState {
  final DashboardModel dashboard;
  DashboardLoaded(this.dashboard);
}

class TransactionsLoaded extends CashflowState {
  final List<TransactionModel> transactions;
  final bool hasMore;
  final int  currentPage;
  TransactionsLoaded({
    required this.transactions,
    required this.hasMore,
    required this.currentPage,
  });
}

class TransactionLoadingMore extends CashflowState {
  final List<TransactionModel> current;
  TransactionLoadingMore(this.current);
}

class TransactionAdded   extends CashflowState {
  final TransactionModel transaction;
  TransactionAdded(this.transaction);
}

class TransactionUpdated extends CashflowState {}
class TransactionDeleted extends CashflowState {}

class CashflowError      extends CashflowState {
  final String message;
  CashflowError(this.message);
}