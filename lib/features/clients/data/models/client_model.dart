class ClientModel {
  final int id;
  final String nom;
  final String prenom;
  final String? nomEntreprise;
  final String? ice;
  final String? email;
  final String? telephone;

  ClientModel({
    required this.id,
    required this.nom,
    required this.prenom,
    this.nomEntreprise,
    this.ice,
    this.email,
    this.telephone,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      id:            json['id'],
      nom:           json['nom'],
      prenom:        json['prenom'] ?? '',
      nomEntreprise: json['nom_entreprise'],
      ice:           json['ice'],
      email:         json['email'],
      telephone:     json['telephone'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id':             id,
    'nom':            nom,
    'prenom':         prenom,
    'nom_entreprise': nomEntreprise,
    'ice':            ice,
    'email':          email,
    'telephone':      telephone,
  };

  String get displayName => nomEntreprise != null && nomEntreprise!.isNotEmpty
      ? '$nom $prenom ($nomEntreprise)'
      : '$nom $prenom';

  String get initials {
    final n = nom.trim().isNotEmpty ? nom.trim()[0] : '';
    final p = prenom.trim().isNotEmpty ? prenom.trim()[0] : '';
    return '$n$p'.toUpperCase();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ClientModel &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;
}