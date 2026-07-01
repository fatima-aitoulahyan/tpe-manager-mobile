class UserModel {
  final int id;
  final String email;
  final String telephone;
  final String nom;
  final String prenom;
  final String? ice;
  final String? statutFiscal;

  UserModel({
    required this.id,
    required this.email,
    required this.telephone,
    required this.nom,
    required this.prenom,
    this.ice,
    this.statutFiscal,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id:            json['id'],
      email:         json['email'],
      telephone:     json['telephone'],
      nom:           json['nom'],
      prenom:        json['prenom'],
      ice:           json['ice'],
      statutFiscal:  json['statut_fiscal'],
    );
  }
}

class AuthTokens {
  final String access;
  final String refresh;

  AuthTokens({required this.access, required this.refresh});

  factory AuthTokens.fromJson(Map<String, dynamic> json) {
    return AuthTokens(
      access:  json['access'],
      refresh: json['refresh'],
    );
  }
}