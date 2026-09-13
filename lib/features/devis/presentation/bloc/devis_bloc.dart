import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../clients/data/datasources/client_remote_datasource.dart';
import '../../data/datasources/devis_remote_datasource.dart';
import '../../data/models/devis_model.dart';
import 'devis_event.dart';
import 'devis_state.dart';

class DevisBloc extends Bloc<DevisEvent, DevisState> {
  final DevisRemoteDataSource _datasource;
  final ClientRemoteDataSource _clientRemoteDataSource;

  DevisBloc(this._datasource , this._clientRemoteDataSource) : super(DevisInitial()) {

    on<LoadDevisList>((event, emit) async {
      emit(DevisLoading());
      try {
        final list = await _datasource.getAll(statut: event.statut);
        emit(DevisListLoaded(list));
      } catch (e) {
        emit(DevisError(e.toString()));
      }
    });

    on<LoadDevisDetail>((event, emit) async {
      emit(DevisLoading());
      try {
        final devis = await _datasource.getOne(event.id);
        emit(DevisDetailLoaded(devis));
      } catch (e) {
        emit(DevisError(e.toString()));
      }
    });

    on<CreateDevis>((event, emit) async {
      emit(DevisLoading());
      try {
        final devis = await _datasource.create(event.data);
        emit(DevisCreated(devis));
      } catch (e) {
        emit(DevisError(e.toString()));
      }
    });

    on<DeleteDevis>((event, emit) async {
      try {
        await _datasource.delete(event.id);
        emit(DevisDeleted());
      } catch (e) {
        emit(DevisError(e.toString()));
      }
    });

    on<ChangeDevisStatus>((event, emit) async {
      try {
        await _datasource.changeStatus(event.id, event.status);
        emit(DevisStatusChanged());
      } catch (e) {
        emit(DevisError(e.toString()));
      }
    });

    on<DuplicateDevis>((event, emit) async {
      try {
        final devis = await _datasource.duplicate(event.id);
        emit(DevisDuplicated(devis));
      } catch (e) {
        emit(DevisError(e.toString()));
      }
    });

    on<LoadClients>((event, emit) async {
      try {
        final clients = await _clientRemoteDataSource.getAll();
        emit(ClientsLoaded(clients));
      } catch (e) {
        emit(DevisError(e.toString()));
      }
    });

    on<DownloadDevisPdf>((event, emit) async {
      DevisModel? currentDevis;
      if (state is DevisDetailLoaded) {
        currentDevis = (state as DevisDetailLoaded).devis;
      }

      try {
        final filePath = await _datasource.downloadPdf(event.id, event.numero);

        if (currentDevis != null) {
          emit(DevisPdfReady(filePath: filePath, numero: event.numero, devis: currentDevis));
        } else {
          final devis = await _datasource.getOne(event.id);
          emit(DevisPdfReady(filePath: filePath, numero: event.numero, devis: devis));
        }
      } catch (e) {
        emit(DevisError(e.toString()));
      }
    });

    on<LoadDevisForEdit>((event, emit) async {
      emit(DevisLoading());
      try {
        final devis = await _datasource.getOne(event.id);
        if (devis.statut != 'BROUILLON') {
          emit(DevisError('Seuls les brouillons de devis peuvent être modifiés.'));
          return;
        }

        emit(DevisLoadedForEdit(devis));
      } catch (e) {
        emit(DevisError(e.toString()));
      }
    });

    on<EditDevis>((event, emit) async {
      emit(DevisLoading());
      try {
        final devis = await _datasource.update(event.id, event.data);
        emit(DevisEditSuccess(devis));
      } catch (e) {
        emit(DevisError(e.toString()));
      }
    });

    on<LoadDevisListPaginated>((event, emit) async {
      if (!event.isLoadMore) {
        emit(DevisLoading());
      } else {
        final currentDevis = state is DevisListPaginatedLoaded
            ? (state as DevisListPaginatedLoaded).devis
            : <DevisListModel>[];
        emit(DevisLoadingMore(currentDevis));
      }

      try {
        final result = await _datasource.getAllPaginated(
          statut:    event.statut,
          clientId:  event.clientId,
          dateDebut: event.dateDebut,
          dateFin:   event.dateFin,
          page:      event.page,
        );

        final newDevis = result['devis'] as List<DevisListModel>;

        if (event.isLoadMore && state is DevisLoadingMore) {
          final existing = (state as DevisLoadingMore).currentDevis;
          emit(DevisListPaginatedLoaded(
            devis:       [...existing, ...newDevis],
            hasMore:     result['hasNext'],
            currentPage: event.page,
          ));
        } else {
          emit(DevisListPaginatedLoaded(
            devis:       newDevis,
            hasMore:     result['hasNext'],
            currentPage: event.page,
          ));
        }
      } catch (e) {
        emit(DevisError(e.toString()));
      }
    });

    on<ConvertDevisToFacture>((event, emit) async {
      emit(DevisLoading());
      try {
        final facture = await _datasource.convertirEnFacture(event.devisId);
        emit(DevisConvertedToFacture(facture['id'] as int));
      } catch (e) {
        emit(DevisError(e.toString()));
      }
    });

    // ── Génération IA : seul et unique handler pour cet event ──
    // Le catch spécifique doit passer AVANT le catch générique,
    // sinon ClientNotFoundAiException finirait dans DevisError comme n'importe quelle autre erreur.
    on<GenerateDevisFromText>((event, emit) async {
      emit(DevisLoading());
      try {
        final data = await _datasource.generateFromText(event.text);
        emit(DevisAiGenerated(data));
      } on ClientNotFoundAiException catch (e) {
        emit(DevisAiClientNotFound(e.clientNomDetecte, e.message));
      } catch (e) {
        emit(DevisError(e.toString()));
      }
    });
  }
}