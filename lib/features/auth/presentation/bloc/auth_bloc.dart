import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../services/fcm_service.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRemoteDataSource _datasource;
  final _storage = const FlutterSecureStorage();

  AuthBloc(this._datasource) : super(AuthInitial()) {

    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final tokens = await _datasource.login(
          email:    event.email,
          password: event.password,
        );
        await _storage.write(key: 'access_token',  value: tokens['access']);
        await _storage.write(key: 'refresh_token', value: tokens['refresh']);
        await FCMService.init();
        final user = await _datasource.getProfile();
        emit(AuthSuccess(user));
      } catch (e) {
        emit(AuthError(_parseError(e)));
      }
    });

    on<RegisterRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final result = await _datasource.register(
          email:           event.email,
          telephone:       event.telephone,
          nom:             event.nom,
          prenom:          event.prenom,
          password:        event.password,
          passwordConfirm: event.passwordConfirm,
          statutFiscal:    event.statutFiscal,
          ice:             event.ice,
        );

        emit(RegisterSuccess());
      } catch (e) {
        emit(AuthError(_parseError(e)));
      }
    });
    on<LogoutRequested>((event, emit) async {
      final refresh = await _storage.read(key: 'refresh_token');
      if (refresh != null) {
        await _datasource.logout(refresh);
      }
      await _storage.deleteAll();
      emit(AuthLoggedOut());
    });

    on<CheckAuthStatus>((event, emit) async {
      await _storage.deleteAll();
      emit(Unauthenticated());
    });    on<ForgotPasswordRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await _datasource.forgotPassword(event.email);
        emit(ForgotPasswordEmailSent());
      } catch (e) {
        emit(AuthError('Erreur lors de l\'envoi du code.'));
      }
    });

    on<VerifyResetCodeRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final valid = await _datasource.verifyResetCode(
            event.email, event.code);
        if (valid) {
          emit(ResetCodeVerified());
        } else {
          emit(AuthError('Code invalide.'));
        }
      } catch (e) {
        emit(AuthError('Code invalide ou expiré.'));
      }
    });

    on<ResetPasswordRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await _datasource.resetPassword(
            event.email, event.code, event.newPassword);
        emit(PasswordResetSuccess());
      } catch (e) {
        emit(AuthError('Erreur lors de la réinitialisation.'));
      }
    });

  }

  String _parseError(dynamic e) {
    if (e is Exception) {
      return e.toString().replaceFirst('Exception: ', '');
    }
    return 'Une erreur inattendue s\'est produite.';
  }
}