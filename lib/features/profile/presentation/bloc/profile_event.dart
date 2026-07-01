import '../../data/models/user_model.dart';

abstract class ProfileEvent {}

class LoadProfile extends ProfileEvent {}

class UpdateProfile extends ProfileEvent {
  final UserModel user;
  UpdateProfile(this.user);
}

class ChangePasswordRequested extends ProfileEvent {
  final String oldPassword;
  final String newPassword;
  ChangePasswordRequested({required this.oldPassword, required this.newPassword});
}

class LogoutRequested extends ProfileEvent {}