class UserModel {
  final int id;
  final String email;
  final String nom;
  final String prenom;
  final String telephone;
  final String? ice;
  final String? statutFiscal;

  UserModel({
    required this.id,
    required this.email,
    required this.nom,
    required this.prenom,
    required this.telephone,
    this.ice,
    this.statutFiscal,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      email: json['email'] as String,
      nom: json['nom'] as String,
      prenom: json['prenom'] as String,
      telephone: json['telephone'] as String,
      ice: json['ice'] as String?,
      statutFiscal: json['statut_fiscal'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nom': nom,
      'prenom': prenom,
      'telephone': telephone,
      'ice': ice,
      'statut_fiscal': statutFiscal,
    };
  }
}