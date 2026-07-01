import '../../data/models/user_model.dart';

abstract class AuthState {}

class AuthInitial    extends AuthState {}
class AuthLoading    extends AuthState {}
class AuthSuccess    extends AuthState {
  final UserModel user;
  AuthSuccess(this.user);
}
class AuthError      extends AuthState {
  final String message;
  AuthError(this.message);
}
class AuthLoggedOut  extends AuthState {}
class Unauthenticated extends AuthState {}
class PasswordResetCodeSent extends AuthState {
  final String email;
  PasswordResetCodeSent(this.email);
}
class RegisterSuccess extends AuthState {}
class ForgotPasswordEmailSent extends AuthState {}
class ResetCodeVerified       extends AuthState {}
class PasswordResetSuccess    extends AuthState {}