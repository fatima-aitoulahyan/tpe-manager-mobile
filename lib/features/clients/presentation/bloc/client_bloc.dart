import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/client_repository.dart';
import '../../data/datasources/client_remote_datasource.dart';
import 'client_event.dart';
import 'client_state.dart';

class ClientBloc extends Bloc<ClientEvent, ClientState> {
  final ClientRepository _repository;

  ClientBloc()
      : _repository = ClientRepository(ClientRemoteDataSource()),
        super(ClientInitial()) {
    on<LoadClients>((event, emit) async {
      emit(ClientLoading());
      try {
        final clients = await _repository.getAll();
        emit(ClientsLoaded(clients));
      } catch (e) {
        emit(ClientError(e.toString()));
      }
    });
    on<LoadClientDetail>((event, emit) async {
      emit(ClientLoading());
      try {
        final client = await _repository.getOne(event.id);
        emit(ClientDetailLoaded(client));
      } catch (e) {
        emit(ClientError(e.toString()));
      }
    });
    on<CreateClient>((event, emit) async {
      emit(ClientLoading());
      try {
        final client = await _repository.create(event.data);
        emit(ClientCreated(client));
      } catch (e) {
        emit(ClientError(e.toString()));
      }
    });
    on<UpdateClient>((event, emit) async {
      emit(ClientLoading());
      try {
        final client = await _repository.update(event.id, event.data);
        emit(ClientUpdated(client));
      } catch (e) {
        emit(ClientError(e.toString()));
      }
    });
    on<DeleteClient>((event, emit) async {
      try {
        await _repository.delete(event.id);
        emit(ClientDeleted());
      } catch (e) {
        emit(ClientError(e.toString()));
      }
    });
    on<SearchClients>((event, emit) {
      if (state is ClientsLoaded) {
        final all = (state as ClientsLoaded).clients;
        final query = event.query.toLowerCase();
        final filtered = query.isEmpty
            ? all
            : all.where((c) =>
        c.nom.toLowerCase().contains(query) ||
            c.prenom.toLowerCase().contains(query) ||
            (c.nomEntreprise?.toLowerCase().contains(query) ?? false) ||
            (c.telephone?.contains(query) ?? false),
        ).toList();
        emit(ClientsLoaded.withFilter(all, filtered));
      }
    });
  }
}