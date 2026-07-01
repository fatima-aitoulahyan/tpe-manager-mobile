import '../../data/models/user_model.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}
class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserModel user;
  final bool emailNotif;
  final bool pushNotif;
  ProfileLoaded({required this.user, this.emailNotif = true, this.pushNotif = true});
}

class ProfileUpdateSuccess extends ProfileState {
  final UserModel user;
  ProfileUpdateSuccess(this.user);
}

class PasswordChangeSuccess extends ProfileState {}
class LogoutSuccess extends ProfileState {}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}
