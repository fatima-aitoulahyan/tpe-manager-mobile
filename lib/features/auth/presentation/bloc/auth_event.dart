abstract class AuthEvent {}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  LoginRequested({required this.email, required this.password});
}

class RegisterRequested extends AuthEvent {
  final String email;
  final String telephone;
  final String nom;
  final String prenom;
  final String password;
  final String passwordConfirm;
  final String? statutFiscal;
  final String? ice;

  RegisterRequested({
    required this.email,
    required this.telephone,
    required this.nom,
    required this.prenom,
    required this.password,
    required this.passwordConfirm,
    this.statutFiscal,
    this.ice,
  });
}

class LogoutRequested extends AuthEvent {}

class CheckAuthStatus extends AuthEvent {}
class RequestPasswordReset extends AuthEvent {
  final String email;
  RequestPasswordReset(this.email);
}

class ForgotPasswordRequested extends AuthEvent {
  final String email;
  ForgotPasswordRequested(this.email);
}

class VerifyResetCodeRequested extends AuthEvent {
  final String email;
  final String code;
  VerifyResetCodeRequested(this.email, this.code);
}

class ResetPasswordRequested extends AuthEvent {
  final String email;
  final String code;
  final String newPassword;
  ResetPasswordRequested(this.email, this.code, this.newPassword);
}