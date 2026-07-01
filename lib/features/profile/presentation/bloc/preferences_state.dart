import '../../data/models/preferences_model.dart';

abstract class PreferencesState {}

class PreferencesInitial extends PreferencesState {}
class PreferencesLoading extends PreferencesState {}

class PreferencesLoaded extends PreferencesState {
  final PreferencesModel preferences;
  PreferencesLoaded(this.preferences);
}

class PreferencesSaving extends PreferencesState {
  final PreferencesModel preferences;
  PreferencesSaving(this.preferences);
}

class PreferencesSaved extends PreferencesState {}

class PreferencesError extends PreferencesState {
  final String message;
  PreferencesError(this.message);
}