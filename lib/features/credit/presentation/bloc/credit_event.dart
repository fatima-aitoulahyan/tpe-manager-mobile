abstract class CreditEvent {}

class LoadEligibilite extends CreditEvent {}

class LoadDemandes extends CreditEvent {
  final String? statut;
  LoadDemandes({this.statut});
}

class LoadDemandeDetail extends CreditEvent {
  final int id;
  LoadDemandeDetail(this.id);
}

class CreateDemande extends CreditEvent {
  final Map<String, dynamic> data;
  CreateDemande(this.data);
}

class DeleteDemande extends CreditEvent {
  final int id;
  DeleteDemande(this.id);
}

class UploadJustificatif extends CreditEvent {
  final int    demandeId;
  final String typeDocument;
  final String filePath;
  UploadJustificatif(this.demandeId, this.typeDocument, this.filePath);
}
