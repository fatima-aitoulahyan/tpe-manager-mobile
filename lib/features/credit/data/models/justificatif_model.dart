class JustificatifModel {
  final int    id;
  final String typeDocument;
  final String fichier;
  final String nomFichier;
  final String uploadedAt;

  JustificatifModel({
    required this.id,
    required this.typeDocument,
    required this.fichier,
    required this.nomFichier,
    required this.uploadedAt,
  });

  factory JustificatifModel.fromJson(Map<String, dynamic> json) {
    return JustificatifModel(
      id:           int.tryParse(json['id'].toString()) ?? 0,
      typeDocument: json['type_document']?.toString() ?? '',
      fichier:      json['fichier']?.toString() ?? '',
      nomFichier:   json['nom_fichier']?.toString() ?? '',
      uploadedAt:   json['uploaded_at']?.toString() ?? '',
    );
  }
}