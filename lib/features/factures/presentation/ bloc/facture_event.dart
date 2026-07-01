import 'package:equatable/equatable.dart';

abstract class FactureEvent extends Equatable {
  const FactureEvent();

  @override
  List<Object?> get props => [];
}
class LoadFactureListPaginated extends FactureEvent {
  final String? statut;
  final int? clientId;
  final String? dateDebut;
  final String? dateFin;
  final int page;
  final bool isLoadMore;

  const LoadFactureListPaginated({
    this.statut,
    this.clientId,
    this.dateDebut,
    this.dateFin,
    this.page = 1,
    this.isLoadMore = false,
  });

  @override
  List<Object?> get props => [statut, clientId, dateDebut, dateFin, page, isLoadMore];
}

class LoadFactureDetail extends FactureEvent {
  final int id;

  const LoadFactureDetail(this.id);

  @override
  List<Object> get props => [id];
}
class CreateFacture extends FactureEvent {
  final Map<String, dynamic> data;

  const CreateFacture(this.data);

  @override
  List<Object> get props => [data];
}
class EditFacture extends FactureEvent {
  final int id;
  final Map<String, dynamic> data;

  const EditFacture({required this.id, required this.data});

  @override
  List<Object> get props => [id, data];
}
class DeleteFacture extends FactureEvent {
  final int id;

  const DeleteFacture(this.id);

  @override
  List<Object> get props => [id];
}
class ChangeFactureStatus extends FactureEvent {
  final int id;
  final String status;

  const ChangeFactureStatus({required this.id, required this.status});

  @override
  List<Object> get props => [id, status];
}
class LoadFactureClients extends FactureEvent {}

class DownloadFacturePdf extends FactureEvent {
  final int id;
  final String numero;

  const DownloadFacturePdf({required this.id, required this.numero});

  @override
  List<Object> get props => [id, numero];
}
class RegisterFacturePayment extends FactureEvent {
  final int id;
  final double montant;

  const RegisterFacturePayment({required this.id, required this.montant});

  @override
  List<Object> get props => [id, montant];
}
class ConvertDevisToFacture extends FactureEvent {
  final int devisId;

  const ConvertDevisToFacture(this.devisId);

  @override
  List<Object> get props => [devisId];
}
class ArchiveFacture extends FactureEvent {
  final int id;
  const ArchiveFacture(this.id);

  @override
  List<Object> get props => [id];
}