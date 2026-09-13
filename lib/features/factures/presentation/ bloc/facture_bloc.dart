import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../clients/data/datasources/client_remote_datasource.dart';
import '../../data/datasources/facture_remote_datasource.dart';
import '../../data/models/facture_model.dart';
import 'facture_event.dart';
import 'facture_state.dart';

class FactureBloc extends Bloc<FactureEvent, FactureState> {
  final FactureRemoteDataSource _datasource;
  final ClientRemoteDataSource _clientRemoteDataSource;

  FactureBloc(this._datasource, this._clientRemoteDataSource) : super(FactureInitial()) {
    on<LoadFactureListPaginated>((event, emit) async {
      if (!event.isLoadMore) {
        emit(FactureLoading());
      } else {
        final currentFactures = state is FactureListPaginatedLoaded
            ? (state as FactureListPaginatedLoaded).factures
            : <FactureModel>[];
        emit(FactureLoadingMore(currentFactures));
      }
      try {
        final result = await _datasource.getAllPaginated(
          statut:    event.statut,
          clientId:  event.clientId,
          dateDebut: event.dateDebut,
          dateFin:   event.dateFin,
          page:      event.page,
        );
        final newFactures = result['factures'] as List<FactureModel>;
        if (event.isLoadMore && state is FactureLoadingMore) {
          final existing = (state as FactureLoadingMore).currentFactures;
          emit(FactureListPaginatedLoaded(
            factures:    [...existing, ...newFactures],
            hasMore:     result['hasNext'],
            currentPage: event.page,
          ));
        } else {
          emit(FactureListPaginatedLoaded(
            factures:    newFactures,
            hasMore:     result['hasNext'],
            currentPage: event.page,
          ));
        }
      } catch (e) {
        emit(FactureError(e.toString()));
      }
    });
    on<LoadFactureDetail>((event, emit) async {
      emit(FactureLoading());
      try {
        final facture = await _datasource.getOne(event.id);
        emit(FactureDetailLoaded(facture));
      } catch (e) {
        emit(FactureError(e.toString()));
      }
    });
    on<CreateFacture>((event, emit) async {
      emit(FactureLoading());
      try {
        final facture = await _datasource.create(event.data);
        emit(FactureCreated(facture));
      } catch (e) {
        emit(FactureError(e.toString()));
      }
    });
    on<EditFacture>((event, emit) async {
      emit(FactureLoading());
      try {
        final facture = await _datasource.update(event.id, event.data);
        emit(FactureEditSuccess(facture));
      } catch (e) {
        emit(FactureError(e.toString()));
      }
    });
    on<DeleteFacture>((event, emit) async {
      try {
        await _datasource.delete(event.id);
        emit(FactureDeleted());
      } catch (e) {
        emit(FactureError(e.toString()));
      }
    });
    on<ChangeFactureStatus>((event, emit) async {
      try {
        await _datasource.changeStatus(event.id, event.status);
        emit(FactureStatusChanged());
      } catch (e) {
        emit(FactureError(e.toString()));
      }
    });
    on<DownloadFacturePdf>((event, emit) async {
      FactureModel? currentFacture;
      if (state is FactureDetailLoaded) {
        currentFacture = (state as FactureDetailLoaded).facture;
      }

      try {
        final filePath = await _datasource.downloadPdf(event.id, event.numero);

        if (currentFacture != null) {
          emit(FacturePdfReady(filePath: filePath, numero: event.numero, facture: currentFacture));
        } else {
          emit(FacturePdfReady(filePath: filePath, numero: event.numero, facture: await _datasource.getOne(event.id)));
        }
      } catch (e) {
        emit(FactureError(e.toString()));
      }
    });
    on<LoadFactureClients>((event, emit) async {
      try {
        final clients = await _clientRemoteDataSource.getAll();
        emit(FactureClientsLoaded(clients));
      } catch (e) {
        emit(FactureError(e.toString()));
      }
    });
    on<RegisterFacturePayment>((event, emit) async {

      try {
        final res = await _datasource.enregistrerPaiement(event.id, event.montant);
        final updatedFacture = await _datasource.getOne(event.id);
        emit(FacturePaymentRegistered(updatedFacture));
      } catch (e) {
        emit(FactureError(e.toString()));
      }
    });
    on<ConvertDevisToFacture>((event, emit) async {
      emit(FactureLoading());
      try {
        final newFacture = await _datasource.convertirDevis(event.devisId);
        emit(FactureCreatedFromDevis(newFacture));
      } catch (e) {
        emit(FactureError(e.toString()));
      }
    });
    on<ArchiveFacture>((event, emit) async {
      try {
        await _datasource.changeStatus(event.id, 'ARCHIVE', motif: event.motif);
        emit(FactureArchived());
      } catch (e) {
        emit(FactureError(e.toString()));
      }
    });
  }
}