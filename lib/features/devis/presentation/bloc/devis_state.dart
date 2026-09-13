import '../../../clients/data/models/client_model.dart';
import '../../data/models/devis_model.dart';


abstract class DevisState {}

class DevisInitial       extends DevisState {}
class DevisLoading       extends DevisState {}
class DevisListLoaded    extends DevisState {
  final List<DevisListModel> devis;
  DevisListLoaded(this.devis);
}
class DevisDetailLoaded  extends DevisState {
  final DevisModel devis;
  DevisDetailLoaded(this.devis);
}
class DevisCreated       extends DevisState {
  final DevisModel devis;
  DevisCreated(this.devis);
}
class DevisUpdated       extends DevisState {}
class DevisDeleted       extends DevisState {}
class DevisStatusChanged extends DevisState {}
class DevisDuplicated    extends DevisState {
  final DevisModel devis;
  DevisDuplicated(this.devis);
}
class ClientsLoaded      extends DevisState {
  final List<ClientModel> clients;
  ClientsLoaded(this.clients);
}
class DevisError         extends DevisState {
  final String message;
  DevisError(this.message);
}

class DevisPdfReady extends DevisState {
  final String filePath;
  final String numero;
  final DevisModel devis;

  DevisPdfReady({required this.filePath, required this.numero, required this.devis});
}
class DevisLoadedForEdit extends DevisState {
  final DevisModel devis;
  DevisLoadedForEdit(this.devis);
}

class DevisEditSuccess extends DevisState {
  final DevisModel devis;
  DevisEditSuccess(this.devis);
}
class DevisListPaginatedLoaded extends DevisState {
  final List<DevisListModel> devis;
  final bool hasMore;
  final int currentPage;

  DevisListPaginatedLoaded({
    required this.devis,
    required this.hasMore,
    required this.currentPage,
  });
}

class DevisLoadingMore extends DevisState {
  final List<DevisListModel> currentDevis;
  DevisLoadingMore(this.currentDevis);
}
class DevisConvertedToFacture extends DevisState {
  final int factureId;
  DevisConvertedToFacture(this.factureId);

  @override
  List<Object> get props => [factureId];
}
class DevisAiGenerated extends DevisState {
  final Map<String, dynamic> data;
  DevisAiGenerated(this.data);
}
class DevisAiClientNotFound extends DevisState {
  final String clientNom;
  final String message;
  DevisAiClientNotFound(this.clientNom, this.message);
}