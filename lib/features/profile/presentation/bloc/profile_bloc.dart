import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasources/profile_remote_datasource.dart';
import '../../data/models/user_model.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRemoteDataSource _dataSource;

  final String _mockAccessToken = "TON_ACCESS_TOKEN_JWT";
  final String _mockRefreshToken = "TON_REFRESH_TOKEN_JWT";

  ProfileBloc(this._dataSource) : super(ProfileInitial()) {

    on<LoadProfile>((event, emit) async {
      emit(ProfileLoading());
      try {
        final user = await _dataSource.getProfile(_mockAccessToken);
        emit(ProfileLoaded(user: user, emailNotif: true, pushNotif: false));
      } catch (e) {
        emit(ProfileError("Impossible de charger le profil : ${e.toString()}"));
      }
    });

    on<UpdateProfile>((event, emit) async {
      final currentState = state;
      try {
        final updatedUser = await _dataSource.updateProfile(_mockAccessToken, event.user);
        emit(ProfileUpdateSuccess(updatedUser));

        if (currentState is ProfileLoaded) {
          emit(ProfileLoaded(
            user: updatedUser,
            emailNotif: currentState.emailNotif,
            pushNotif: currentState.pushNotif,
          ));
        }
      } catch (e) {
        emit(ProfileError("Échec de la mise à jour des coordonnées"));
      }
    });

    on<ChangePasswordRequested>((event, emit) async {
      try {
        await _dataSource.changePassword(_mockAccessToken, event.oldPassword, event.newPassword);
        emit(PasswordChangeSuccess());
      } catch (e) {
        emit(ProfileError("Ancien mot de passe incorrect ou invalide"));
      }
    });

    on<LogoutRequested>((event, emit) async {
      emit(ProfileLoading());
      try {
        await _dataSource.logout(_mockAccessToken, _mockRefreshToken);
        emit(LogoutSuccess());
      } catch (e) {
        emit(ProfileError("Erreur lors de la déconnexion."));
      }
    });
  }
}