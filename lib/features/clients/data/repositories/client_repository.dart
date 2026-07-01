import '../datasources/client_remote_datasource.dart';
import '../models/client_model.dart';

class ClientRepository {
  final ClientRemoteDataSource _datasource;

  ClientRepository(this._datasource);

  Future<List<ClientModel>> getAll() => _datasource.getAll();
  Future<ClientModel> getOne(int id) => _datasource.getOne(id);
  Future<ClientModel> create(Map<String, dynamic> data) =>
      _datasource.create(data);
  Future<ClientModel> update(int id, Map<String, dynamic> data) =>
      _datasource.update(id, data);
  Future<void> delete(int id) => _datasource.delete(id);
}