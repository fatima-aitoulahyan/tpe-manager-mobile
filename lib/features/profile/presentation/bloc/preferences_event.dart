import '../../data/models/preferences_model.dart';

abstract class PreferencesEvent {}

class LoadPreferences extends PreferencesEvent {}

class UpdatePreferences extends PreferencesEvent {
  final PreferencesModel preferences;
  UpdatePreferences(this.preferences);
}