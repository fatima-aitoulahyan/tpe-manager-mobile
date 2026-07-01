import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasources/credit_remote_datasource.dart';
import 'credit_event.dart';
import 'credit_state.dart';

class CreditBloc extends Bloc<CreditEvent, CreditState> {
  final CreditRemoteDataSource dataSource;

  CreditBloc(this.dataSource) : super(CreditInitial()) {

    on<LoadEligibilite>((event, emit) async {
      emit(CreditLoading());
      try {
        final elig = await dataSource.getEligibilite();
        emit(EligibiliteLoaded(elig));
      } catch (e) {
        emit(CreditError(e.toString()));
      }
    });

    on<LoadDemandes>((event, emit) async {
      emit(CreditLoading());
      try {
        final demandes = await dataSource.getDemandes(
            statut: event.statut);
        emit(DemandesLoaded(demandes));
      } catch (e) {
        emit(CreditError(e.toString()));
      }
    });

    on<LoadDemandeDetail>((event, emit) async {
      emit(CreditLoading());
      try {
        final demande = await dataSource.getDemande(event.id);
        emit(DemandeDetailLoaded(demande));
      } catch (e) {
        emit(CreditError(e.toString()));
      }
    });

    on<CreateDemande>((event, emit) async {
      emit(CreditLoading());
      try {
        final demande = await dataSource.createDemande(event.data);
        emit(DemandeCreated(demande));
      } catch (e) {
        emit(CreditError(e.toString()));
      }
    });

    on<DeleteDemande>((event, emit) async {
      print('🔴 DeleteDemande event reçu avec id: ${event.id}');
      try {
        await dataSource.deleteDemande(event.id);
        print('✅ Suppression réussie côté API');
        emit(DemandeDeleted());
      } catch (e) {
        print('❌ Erreur: $e');
        emit(CreditError(e.toString()));
      }
    });

    on<UploadJustificatif>((event, emit) async {
      try {
        await dataSource.uploadJustificatif(
            event.demandeId, event.typeDocument, event.filePath);
        emit(JustificatifUploaded());
        add(LoadDemandeDetail(event.demandeId));
      } catch (e) {
        emit(CreditError(e.toString()));
      }
    });
  }
}