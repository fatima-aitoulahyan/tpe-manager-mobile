import '../../data/models/client_model.dart';

abstract class ClientState {}

class ClientInitial      extends ClientState {}
class ClientLoading      extends ClientState {}
class ClientsLoaded      extends ClientState {
  final List<ClientModel> clients;
  final List<ClientModel> filtered;
  ClientsLoaded(this.clients) : filtered = clients;
  ClientsLoaded.withFilter(this.clients, this.filtered);
}
class ClientDetailLoaded extends ClientState {
  final ClientModel client;
  ClientDetailLoaded(this.client);
}
class ClientCreated      extends ClientState {
  final ClientModel client;
  ClientCreated(this.client);
}
class ClientUpdated      extends ClientState {
  final ClientModel client;
  ClientUpdated(this.client);
}
class ClientDeleted      extends ClientState {}
class ClientError        extends ClientState {
  final String message;
  ClientError(this.message);
}