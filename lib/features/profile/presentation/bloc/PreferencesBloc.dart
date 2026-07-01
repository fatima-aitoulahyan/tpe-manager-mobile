import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tpe_mobile/features/profile/presentation/bloc/preferences_state.dart';
import '../../data/datasources/preferences_remote_datasource.dart';
import 'preferences_event.dart';

class PreferencesBloc extends Bloc<PreferencesEvent, PreferencesState> {
  final PreferencesRemoteDataSource _dataSource;

  PreferencesBloc(this._dataSource) : super(PreferencesInitial()) {

    on<LoadPreferences>((event, emit) async {
      emit(PreferencesLoading());
      try {
        final prefs = await _dataSource.getPreferences();
        emit(PreferencesLoaded(prefs));
      } catch (e) {
        emit(PreferencesError(e.toString()));
      }
    });

    on<UpdatePreferences>((event, emit) async {
      emit(PreferencesSaving(event.preferences));
      try {
        final updated = await _dataSource.updatePreferences(event.preferences);
        emit(PreferencesLoaded(updated));
      } catch (e) {
        emit(PreferencesError(e.toString()));
      }
    });
  }
}