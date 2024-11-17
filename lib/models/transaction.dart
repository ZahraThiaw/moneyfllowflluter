class Transaction {
  final int id;
  final double montant;
  final double frais;
  final double montantTotal;
  final String type;
  final DateTime date;
  final UserInfo expediteur;
  final UserInfo destinataire;
  final String status;

  Transaction({
    required this.id,
    required this.montant,
    required this.frais,
    required this.montantTotal,
    required this.type,
    required this.date,
    required this.expediteur,
    required this.destinataire,
    required this.status,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as int,
      montant: (json['montant'] as num).toDouble(),
      frais: (json['frais'] as num).toDouble(),
      montantTotal: (json['montantTotal'] as num).toDouble(),
      type: json['type'] as String,
      date: DateTime.parse(json['date'] as String),
      expediteur: UserInfo.fromJson(json['expediteur'] as Map<String, dynamic>),
      destinataire: UserInfo.fromJson(json['destinataire'] as Map<String, dynamic>),
      status: json['status'] as String,
    );
  }
}

// UserInfo model for transaction participants
class UserInfo {
  final int id;
  final String nom;
  final String prenom;
  final String telephone;
  final String email;
  final double solde;
  final String? role;
  final String? type;
  final String? statut;
  final String? qrcode;

  UserInfo({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.telephone,
    required this.email,
    required this.solde,
    this.role,
    this.type,
    this.statut,
    this.qrcode,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id'] as int,
      nom: json['nom'] as String,
      prenom: json['prenom'] as String,
      telephone: json['telephone'] as String,
      email: json['email'] as String,
      solde: (json['solde'] as num).toDouble(),
      role: json['role'] as String?,
      type: json['type'] as String?,
      statut: json['statut'] as String?,
      qrcode: json['qrcode'] as String?,
    );
  }
}