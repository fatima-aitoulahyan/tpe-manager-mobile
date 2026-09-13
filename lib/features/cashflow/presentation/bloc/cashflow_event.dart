abstract class CashflowEvent {}

class LoadDashboard extends CashflowEvent {}

class LoadTransactions extends CashflowEvent {
  final String? type;
  final String? categorie;
  final String? dateDebut;
  final String? dateFin;
  final String? search;
  final int     page;
  final bool    isLoadMore;

  LoadTransactions({
    this.type,
    this.categorie,
    this.dateDebut,
    this.dateFin,
    this.search,
    this.page       = 1,
    this.isLoadMore = false,
  });
}

class AddTransaction extends CashflowEvent {
  final Map<String, dynamic> data;
  AddTransaction(this.data);
}

class UpdateTransaction extends CashflowEvent {
  final int id;
  final Map<String, dynamic> data;
  UpdateTransaction(this.id, this.data);
}

class DeleteTransaction extends CashflowEvent {
  final int id;
  DeleteTransaction(this.id);
}