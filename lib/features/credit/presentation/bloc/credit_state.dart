import '../../data/models/demande_model.dart';
import '../../data/models/eligibilite_model.dart';

abstract class CreditState {}

class CreditInitial extends CreditState {}
class CreditLoading extends CreditState {}

class EligibiliteLoaded extends CreditState {
  final EligibiliteModel eligibilite;
  EligibiliteLoaded(this.eligibilite);
}

class DemandesLoaded extends CreditState {
  final List<DemandeListModel> demandes;
  DemandesLoaded(this.demandes);
}

class DemandeDetailLoaded extends CreditState {
  final DemandeModel demande;
  DemandeDetailLoaded(this.demande);
}

class DemandeCreated extends CreditState {
  final DemandeModel demande;
  DemandeCreated(this.demande);
}

class DemandeDeleted extends CreditState {}

class JustificatifUploaded extends CreditState {}

class CreditError extends CreditState {
  final String message;
  CreditError(this.message);
}