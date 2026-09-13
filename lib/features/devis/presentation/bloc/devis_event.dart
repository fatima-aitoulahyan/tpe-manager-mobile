import '../../data/models/devis_model.dart';

abstract class DevisEvent {}

class LoadDevisList extends DevisEvent {
  final String? statut;
  LoadDevisList({this.statut});
}

class LoadDevisDetail extends DevisEvent {
  final int id;
  LoadDevisDetail(this.id);
}

class CreateDevis extends DevisEvent {
  final Map<String, dynamic> data;
  CreateDevis(this.data);
}

class UpdateDevis extends DevisEvent {
  final int id;
  final Map<String, dynamic> data;
  UpdateDevis(this.id, this.data);
}

class DeleteDevis extends DevisEvent {
  final int id;
  DeleteDevis(this.id);
}

class ChangeDevisStatus extends DevisEvent {
  final int id;
  final String status;
  ChangeDevisStatus(this.id, this.status);
}

class DuplicateDevis extends DevisEvent {
  final int id;
  DuplicateDevis(this.id);
}
class DownloadDevisPdf extends DevisEvent {
  final int id;
  final String numero;
  DownloadDevisPdf(this.id, this.numero);
}
class LoadClients extends DevisEvent {}

class LoadDevisForEdit extends DevisEvent {
  final int id;
  LoadDevisForEdit(this.id);
}

class EditDevis extends DevisEvent {
  final int id;
  final Map<String, dynamic> data;
  EditDevis(this.id, this.data);
}
class LoadDevisListPaginated extends DevisEvent {
  final String? statut;
  final int?    clientId;
  final String? dateDebut;
  final String? dateFin;
  final int     page;
  final bool    isLoadMore;

  LoadDevisListPaginated({
    this.statut,
    this.clientId,
    this.dateDebut,
    this.dateFin,
    this.page       = 1,
    this.isLoadMore = false,
  });
}
class ConvertDevisToFacture extends DevisEvent {
  final int devisId;
  ConvertDevisToFacture(this.devisId);

  @override
  List<Object> get props => [devisId];
}
class GenerateDevisFromText extends DevisEvent {
  final String text;
  GenerateDevisFromText(this.text);
}
