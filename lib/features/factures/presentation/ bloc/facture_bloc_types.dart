import '../../data/datasources/facture_remote_datasource.dart';
import '../../../clients/data/datasources/client_remote_datasource.dart';
import 'facture_bloc.dart';

class ActiveFactureBloc extends FactureBloc {
  ActiveFactureBloc(FactureRemoteDataSource ds, ClientRemoteDataSource cds)
      : super(ds, cds);
}

class ArchivedFactureBloc extends FactureBloc {
  ArchivedFactureBloc(FactureRemoteDataSource ds, ClientRemoteDataSource cds)
      : super(ds, cds);
}