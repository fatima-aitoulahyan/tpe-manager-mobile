import 'package:equatable/equatable.dart';
import '../../../clients/data/models/client_model.dart';
import '../../data/models/facture_model.dart';

abstract class FactureState extends Equatable {
  const FactureState();

  @override
  List<Object?> get props => [];
}
class FactureInitial extends FactureState {}
class FactureLoading extends FactureState {}
class FactureListPaginatedLoaded extends FactureState {
  final List<FactureModel> factures;
  final bool hasMore;
  final int currentPage;

  const FactureListPaginatedLoaded({
    required this.factures,
    required this.hasMore,
    required this.currentPage,
  });

  @override
  List<Object> get props => [factures, hasMore, currentPage];
}

class FactureLoadingMore extends FactureState {
  final List<FactureModel> currentFactures;

  const FactureLoadingMore(this.currentFactures);

  @override
  List<Object> get props => [currentFactures];
}

class FactureDetailLoaded extends FactureState {
  final FactureModel facture;

  const FactureDetailLoaded(this.facture);

  @override
  List<Object> get props => [facture];
}
class FactureCreated extends FactureState {
  final FactureModel facture;

  const FactureCreated(this.facture);

  @override
  List<Object> get props => [facture];
}

class FactureEditSuccess extends FactureState {
  final FactureModel facture;

  const FactureEditSuccess(this.facture);

  @override
  List<Object> get props => [facture];
}

class FactureDeleted extends FactureState {}
class FactureStatusChanged extends FactureState {}

class FactureClientsLoaded extends FactureState {
  final List<ClientModel> clients;

  const FactureClientsLoaded(this.clients);

  @override
  List<Object> get props => [clients];
}

class FacturePdfReady extends FactureState {
  final String filePath;
  final String numero;
  final FactureModel facture;

  const FacturePdfReady({
    required this.filePath,
    required this.numero,
    required this.facture,
  });

  @override
  List<Object?> get props => [filePath, numero, facture];
}
class FacturePaymentRegistered extends FactureState {
  final FactureModel updatedFacture;

  const FacturePaymentRegistered(this.updatedFacture);

  @override
  List<Object> get props => [updatedFacture];
}

class FactureCreatedFromDevis extends FactureState {
  final FactureModel facture;

  const FactureCreatedFromDevis(this.facture);

  @override
  List<Object> get props => [facture];
}
class FactureError extends FactureState {
  final String message;

  const FactureError(this.message);

  @override
  List<Object> get props => [message];
}
class FactureArchived extends FactureState {}