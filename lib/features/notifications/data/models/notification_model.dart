class NotificationModel {
  final int     id;
  final String  titre;
  final String  corps;
  final String  type;
  final String? referenceId;
  final bool    lue;
  final String  createdAt;

  NotificationModel({
    required this.id,
    required this.titre,
    required this.corps,
    required this.type,
    this.referenceId,
    required this.lue,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id:          int.tryParse(json['id'].toString()) ?? 0,
      titre:       json['titre']?.toString()       ?? '',
      corps:       json['corps']?.toString()       ?? '',
      type:        json['type']?.toString()        ?? '',
      referenceId: json['reference_id']?.toString(),
      lue:         json['lue'] ?? false,
      createdAt:   json['created_at']?.toString()  ?? '',
    );
  }

}