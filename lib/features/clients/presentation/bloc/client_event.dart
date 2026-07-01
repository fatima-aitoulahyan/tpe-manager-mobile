abstract class ClientEvent {}

class LoadClients    extends ClientEvent {}

class LoadClientDetail extends ClientEvent {
  final int id;
  LoadClientDetail(this.id);
}

class CreateClient extends ClientEvent {
  final Map<String, dynamic> data;
  CreateClient(this.data);
}

class UpdateClient extends ClientEvent {
  final int id;
  final Map<String, dynamic> data;
  UpdateClient(this.id, this.data);
}

class DeleteClient extends ClientEvent {
  final int id;
  DeleteClient(this.id);
}

class SearchClients extends ClientEvent {
  final String query;
  SearchClients(this.query);
}